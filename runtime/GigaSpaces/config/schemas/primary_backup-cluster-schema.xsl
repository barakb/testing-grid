<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2005/02/xpath-functions">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:template name="create-backups">
		<xsl:param name="count" select="0"/>
		<xsl:param name="mem-name" select="mem-name"/>
		<xsl:param name="space-name" select="space-name"/>
		<xsl:param name="with-urls" select="1"/>
		<xsl:param name="source" select="1"/>
		<xsl:param name="only" select="1"/>
		<xsl:variable name="groups-value" select="@jini-groups" />
		<xsl:if test="$count > 0">
			<xsl:choose>
				<xsl:when test="$source=1">
					<backup-member>
						<xsl:value-of select="@backup-container"/>_<xsl:value-of select="$count"/>:<xsl:value-of select="$space-name"/>
					</backup-member>
				</xsl:when>
				<xsl:when test="$only=1">
					<backup-member-only>
						<xsl:value-of select="@backup-container"/>_<xsl:value-of select="$count"/>:<xsl:value-of select="$space-name"/>
					</backup-member-only>
				</xsl:when>
				<xsl:otherwise>
					<member>
						<member-name>
							<xsl:value-of select="@backup-container"/>_<xsl:value-of select="$count"/>:<xsl:value-of select="$space-name"/>
						</member-name>
						<xsl:if test="$with-urls='1'">
							<member-url><xsl:value-of select="@member-prefix"/><xsl:value-of select="@backup-container"/>_<xsl:value-of select="$count"/>/<xsl:value-of select="$space-name"/><xsl:value-of select="$groups-value"/>
							</member-url>
						</xsl:if>
					</member>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="create-backups">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="mem-name" select="$mem-name"/>
				<xsl:with-param name="space-name" select="$space-name"/>
				<xsl:with-param name="with-urls" select="$with-urls"/>
				<xsl:with-param name="source" select="$source"/>
				<xsl:with-param name="only" select="$only"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/">
		<cluster-config>
			<xsl:copy-of select="cluster-config/cluster-name"/>
			<xsl:copy-of select="cluster-config/dist-cache"/>
			<xsl:copy-of select="cluster-config/jms"/>
			<description>This topology constructs backup(s) spaces for a primary space. Replication from source space to backup space(s) is done in synchronous manner.</description>
			<notify-recovery>true</notify-recovery>
			<cache-loader>
				<external-data-source>${com.gs.cluster.cache-loader.external-data-source}</external-data-source>
				<central-data-source>${com.gs.cluster.cache-loader.central-data-source}</central-data-source>
			</cache-loader>
			<mirror-service>
	            <enabled>false</enabled>
	            <url>jini://*/mirror-service_container/mirror-service</url>
	            <bulk-size>100</bulk-size>
	            <interval-millis>2000</interval-millis>
	            <interval-opers>100</interval-opers>
	        </mirror-service>
			<cluster-members>
				<xsl:for-each select="cluster-config/cluster-members/member">
					<xsl:variable name="mem-name" select="member-name"/>
					<xsl:variable name="mem-url" select="member-url"/>
					<xsl:variable name="space-name" select="substring-after($mem-name,':')"/>
					<member>
						<member-name>
							<xsl:value-of select="$mem-name"/>
						</member-name>
						<member-url>
							<xsl:value-of select="$mem-url"/>
						</member-url>
					</member>
					<xsl:call-template name="create-backups">
						<xsl:with-param name="count" select="@number-backups"/>
						<xsl:with-param name="mem-name" select="$mem-name"/>
						<xsl:with-param name="space-name" select="$space-name"/>
						<xsl:with-param name="with-urls" select="1"/>
						<xsl:with-param name="source" select="0"/>
						<xsl:with-param name="only" select="0"/>
					</xsl:call-template>
				</xsl:for-each>
			</cluster-members>
			<groups>
				<group>
					<group-name>primary_backup</group-name>
					<group-members>
						<xsl:for-each select="cluster-config/cluster-members/member">
							<xsl:variable name="mem-name" select="member-name"/>
							<xsl:variable name="mem-url" select="member-url"/>
							<xsl:variable name="space-name" select="substring-after($mem-name,':')"/>
							<member>
								<member-name>
									<xsl:value-of select="$mem-name"/>
								</member-name>
							</member>
							<xsl:call-template name="create-backups">
								<xsl:with-param name="count" select="@number-backups"/>
								<xsl:with-param name="mem-name" select="$mem-name"/>
								<xsl:with-param name="space-name" select="$space-name"/>
								<xsl:with-param name="with-urls" select="0"/>
								<xsl:with-param name="source" select="0"/>
								<xsl:with-param name="only" select="0"/>
							</xsl:call-template>
						</xsl:for-each>
					</group-members>
					<load-bal-policy>
						<load-bal-impl-class>com.gigaspaces.cluster.loadbalance.LoadBalanceImpl</load-bal-impl-class>
						<apply-ownership>false</apply-ownership>						
						<disable-parallel-scattering>false</disable-parallel-scattering>						
						<proxy-broadcast-threadpool-min-size>4</proxy-broadcast-threadpool-min-size>
						<proxy-broadcast-threadpool-max-size>64</proxy-broadcast-threadpool-max-size>
						<default>
							<policy-type>local-space</policy-type>
							<broadcast-condition>broadcast-disabled</broadcast-condition>
						</default>
					</load-bal-policy>
					<fail-over-policy>
						<fail-back>false</fail-back>
						<fail-over-find-timeout>2000</fail-over-find-timeout>
						<default>
							<policy-type>fail-to-backup</policy-type>
							<disable-alternate-group>false</disable-alternate-group>
							<backup-members>
								<xsl:for-each select="cluster-config/cluster-members/member">
									<xsl:variable name="mem-name" select="member-name"/>
									<xsl:variable name="mem-url" select="member-url"/>
									<xsl:variable name="space-name" select="substring-after($mem-name,':')"/>
									<member>
										<source-member>
											<xsl:value-of select="$mem-name"/>
										</source-member>
										<xsl:call-template name="create-backups">
											<xsl:with-param name="count" select="@number-backups"/>
											<xsl:with-param name="mem-name" select="$mem-name"/>
											<xsl:with-param name="space-name" select="$space-name"/>
											<xsl:with-param name="with-urls" select="0"/>
											<xsl:with-param name="source" select="1"/>
											<xsl:with-param name="only" select="0"/>
										</xsl:call-template>
									</member>
								</xsl:for-each>
							</backup-members>
							<backup-members-only>
								<xsl:for-each select="cluster-config/cluster-members/member">
									<xsl:variable name="mem-name" select="member-name"/>
									<xsl:variable name="mem-url" select="member-url"/>
									<xsl:variable name="space-name" select="substring-after($mem-name,':')"/>
									<xsl:call-template name="create-backups">
										<xsl:with-param name="count" select="@number-backups"/>
										<xsl:with-param name="mem-name" select="$mem-name"/>
										<xsl:with-param name="space-name" select="$space-name"/>
										<xsl:with-param name="with-urls" select="0"/>
										<xsl:with-param name="source" select="0"/>
										<xsl:with-param name="only" select="1"/>
									</xsl:call-template>
								</xsl:for-each>
							</backup-members-only>
						</default>
						<active-election>
						   <connection-retries>60</connection-retries>
						   <yield-time>1000</yield-time>
						   <fault-detector>
						      <invocation-delay>1000</invocation-delay>
						      <retry-count>3</retry-count>
						      <retry-timeout>100</retry-timeout>
						   </fault-detector>   		
						</active-election>							
					</fail-over-policy>
				</group>
				<xsl:for-each select="cluster-config/cluster-members/member">
					<xsl:variable name="mem-name" select="member-name"/>
					<xsl:variable name="mem-url" select="member-url"/>
					<xsl:variable name="space-name" select="substring-after($mem-name,':')"/>
					<group>
						<group-name>replGroup<xsl:value-of select="$space-name"/>_<xsl:value-of select="position()-1"/>
						</group-name>
						<group-members>
							<member>
								<member-name>
									<xsl:value-of select="$mem-name"/>
								</member-name>
							</member>
							<xsl:call-template name="create-backups">
								<xsl:with-param name="count" select="@number-backups"/>
								<xsl:with-param name="mem-name" select="$mem-name"/>
								<xsl:with-param name="space-name" select="$space-name"/>
								<xsl:with-param name="with-urls" select="0"/>
								<xsl:with-param name="source" select="0"/>
								<xsl:with-param name="only" select="0"/>
							</xsl:call-template>
						</group-members>
						<repl-policy>
							<replication-mode>sync</replication-mode>
							<policy-type>full-replication</policy-type>
							<recovery>true</recovery>
							<replicate-notify-templates>true</replicate-notify-templates>
							<trigger-notify-templates>false</trigger-notify-templates>
							<repl-find-timeout>5000</repl-find-timeout>
							<repl-find-report-interval>30000</repl-find-report-interval>
	                        <repl-original-state>false</repl-original-state>
							<communication-mode>unicast</communication-mode>
							<redo-log-capacity>-1</redo-log-capacity>
							<recovery-chunk-size>1000</recovery-chunk-size>
							<async-replication>
							    <sync-on-commit>false</sync-on-commit>
							    <sync-on-commit-timeout>300000</sync-on-commit-timeout>
							    <repl-chunk-size>500</repl-chunk-size>
							    <repl-interval-millis>3000</repl-interval-millis>
							    <repl-interval-opers>500</repl-interval-opers>
                                <reliable>true</reliable>
                            </async-replication>
							<sync-replication>
							    <todo-queue-timeout>1500</todo-queue-timeout>
							    <hold-txn-lock>false</hold-txn-lock>
							    <multiple-opers-chunk-size>-1</multiple-opers-chunk-size>
							    <unicast>
								    <min-work-threads>4</min-work-threads>
								    <max-work-threads>16</max-work-threads>
							    </unicast>
							    <multicast>
								    <ip-group>224.0.0.1</ip-group>
								    <port>28672</port>
								    <ttl>4</ttl>
								    <min-work-threads>4</min-work-threads>
								    <max-work-threads>16</max-work-threads>
							    </multicast>
							</sync-replication>
						</repl-policy>
					</group>
				</xsl:for-each>
			</groups>
		</cluster-config>
	</xsl:template>
</xsl:stylesheet>
