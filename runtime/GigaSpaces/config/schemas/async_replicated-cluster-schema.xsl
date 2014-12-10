<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
<xsl:template match="/">
	<cluster-config>
		<xsl:copy-of select="cluster-config/cluster-name"/>
		<xsl:copy-of select="cluster-config/dist-cache"/>
		<xsl:copy-of select="cluster-config/jms"/>
		<description>This topology replicates data in an asynchronous manner between source and target space. Data may not be coherent across the different spaces. Replication does not effect application performance.</description>
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
			<xsl:copy-of select="cluster-config/cluster-members/member"/>
		</cluster-members>
		<groups>
			<group>
				<group-name>async_replicated_group</group-name>
					<group-members>
						<xsl:copy-of select="cluster-config/cluster-members/member"/>
					</group-members>
					<repl-policy>
						<replication-mode>async</replication-mode>
	                    <policy-type>full-replication</policy-type>
	                    <recovery>true</recovery>
	                    <replicate-notify-templates>false</replicate-notify-templates>
	                    <trigger-notify-templates>true</trigger-notify-templates>
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
                                <reliable>false</reliable>
                        </async-replication>
	                    <sync-replication>
	                            <todo-queue-timeout>1500</todo-queue-timeout>
	                             <hold-txn-lock>false</hold-txn-lock>
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
						<fail-back>true</fail-back>
						<fail-over-find-timeout>2000</fail-over-find-timeout>
						<default>
							<policy-type>fail-in-group</policy-type>
							<disable-alternate-group>false</disable-alternate-group>
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
			</groups>
	</cluster-config>
</xsl:template>
</xsl:stylesheet>