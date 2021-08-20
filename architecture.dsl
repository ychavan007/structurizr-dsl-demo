workspace "NOV Connect" "NOV Connect solution" {

    model {

        //users

        rigUser = person "RigUser" ""

        officeUser = person "Office User"

        //customer systems
        customerFTPServer = softwareSystem "Customer FTP Server" "FTP"
        customerSFTPServer = softwareSystem "Customer SFTP Server" "FTP"
        customerFileSystem = softwareSystem "Customer File system (local)" "Folder" "Folder"
        customerPrinter = softwareSystem "Customer Printer" "Printer" "Printer"

        enterprise "WBT Software" {

            //infrastructure systems
            emailprovider = softwareSystem "Email System" "Email"
            SFTPServer = softwareSystem "SFTP Server" "FTP"

            //software systems

            rigSenseSystem = softwareSystem "RigSense" "RigSense" {
                edrClientContainer = container "EDR Controls Client" "C#" "Windows App/Controls"
                pipeTallyClientContainer = container "PipeTally Client" "C++" "ActiveX"
                RMSClientContainer = container "RMS Client" "C++" "ActiveX"
                processManagerClientContainer = container "Process Manger Client" "C#" "Windows Service"
                wellDataUploaderContainer = container "WellData Uploader" "C#" "Windows App"
                rigSenseAccessNOVClientContainer = container "WellData Max Browser" "Embedded Browser" "WebBrowswer" "WebBrowser"
            }

            novConnectSystem = softwareSystem "NOVConnect" "NOVConnect" {
                rigSenseConfigToolContainer = container "Config Tool" "C#" "Windows App"
                dataSourcesContainer = container "DataSources" "C#" "Windows Process"
                databaseContainer = container "MainDatabase" "Main System Database" "SQL Server Database Schema" "Database"
                thirdPartyDatabaseContainer = container "3rdPartyDatabase" "3rd Party WITSML Database" "SQLite Database Schema" "Database"
                TnDDatabaseContainer = container "T&DDatabase" "Torque and Drag Database" "SQLite Database Schema" "Database"
                configurationServicesContainer = container "Configuration Services" "Manages installation configuration" "Windows Service"
                dataSourceServicesContainer = container "DataSource Services" "Recieves data from DataSources" "Windows Service"
                channelDataServicesContainer = container "Channel Data Services" "Provides Channel Data to other services" "Windows Service"
                wcfServicesContainer = container "WCF Services" "Manages WCF Connects for Core sync framework" "Windows Service"
                backupServicesContainer = container "Backup Services" "Services to backup information to WellData" "Windows Service"
                wellDataServicesContainer = container "WellData Services" "Allows file upload to WellData" "Windows Service"
                rmsServerContainer = container "RMS Server" "Server for RMS" "Windows Service"
                witsmlContainer = container "WITSML 1.3.1" "C#" "Web Server"
                webRTServerContainer = container "WebRTServer" "C#" "Windows Service"
                pipeTallyServer = container "PipeTallyServer" "C#" "Windows Service"
                virtualChannelsContainer = container "VirtualChannels" "C#" 
                novConnectBackupServicesContainer = container "BackupServices" "C#"
            }

            wellDataClientSystems = softwareSystem "WellDataClient" "WellDataClient"{
                winsClientContainer = container "WINS Client" "File Upload client for WellData" "Windows Service"
                wellDataWebClientContainer = container "WellData" "Website for users" "WebBrowser" "WebBrowser"
                UVRTClientContainer = container "UVRT" "C#" "ClickOnceApp"
                MobileRTClientContainer = container "MobileRT" "C#" "MobileRT" "MobileDevicePortrait"
                welldataAccessNOVClientContainer = container "WellData Max Browser" "Embedded Browser" "WebBrowswer" "WebBrowser"
                welldataRMSListClientContainer = container "RMS List Management Website" "Website to manage RMS Lists" "WebBrowser" "WebBrowser"
                // plugin doesn't support groups yet, will work on this later.
                // welldataTX = group "welldataTX" {
                    wellDataTXViewerContainer = container "WellDataTX Viewer" "Viewer to see downloaded reports (PDFs)"
                    wellDataTXManagerContainer = container "WellDataTX Manager" "Tool to configure WTX Client properties"
                    wellDataTXClientContainer = container "WellDataTX Client" "Service to pull reports" "Windows Service"
                    wellDataTXUpdaterContiner = container "AutoUpdate Client for WellDataTX" "Automatically Updates WellDataTX" "Windwos Service"
                // }
                
                wellDataTXClientContainer -> customerPrinter "prints"
                wellDataTXClientContainer -> customerFileSystem "saves"
                wellDataTXManagerContainer -> wellDataTXClientContainer "saves configuration/starts & stops service"
                wellDataTXViewerContainer -> customerFileSystem "loads"
            }

            wellDataSystem = softwareSystem "WellData" "WellData" {
                winsServerContainer = container "WINS Server" "Recieves Files from data sources" "WebServer"
                winsProcessorContainer = container "WINS Processor Host" "Processes files recieved" "Windows Services"
                winsWatchdogContainer = container "Wins Watchdog" "Notification Service WINS" "Windows Service"
                wellDataRTContainer = container "WellData RT Server" "C#" "Windows Service"
                wellDataRestAPIContainer = container "WellData RestAPI" "C#" "WebServer"
                wellDataDatabaseContainer = container "ChimonetDatabase" "Main System Database" "SQL Server Database Schema" "Database"
                wellDataRTDatabaseContainer = container "UVRTDatabase" "Main System Database" "SQL Server Database Schema" "Database"
                wellDataWebSiteContainer = container "WellData Website" "WellData Main Website" "WebServer"
                wellDataEXContainer = container "WellDataEX" "Automated Report send system" "Windows Service"
                EDRDataServerContainer = container "EDRS" "Service for sensor and other types of data" "Windows Service"
                wellDataDXContianer = container "WellDataDX" "Automated sensor data extractor" "Windows Service"
                wellDataAuthenticatorContainer = container "WellData Authenticator Service" "Service to handle authentication for WellData users" "Windows Service"
                wellData24x7Container = container "24x7 service" "Service to automatically send payroll information" "Windows Service"
                wellDataReportServiceContainer = container "WellData Report Service" "Service to generate RMS and RMS Summary Reports" "Windows Service"
                wellDataRMSListServerContainer = container "Website for RMS ListServer" "Provides RMS Lists" "WebServer"
                welldataTXContainer = container "WellDataTX" "Server to provide Data to WellDataTX" "WebServer"

                wellDataRestAPIContainer -> wellDataDatabaseContainer "reads/writes"
                wellDataRestAPIContainer -> wellDataRTContainer "subscribes to"
                wellDataWebSiteContainer -> wellDataDatabaseContainer "reads/writes"
                wellDataRTContainer -> wellDataRTDatabaseContainer "reads/writes"
                winsServerContainer -> wellDataDatabaseContainer "reads/writes"
                winsProcessorContainer -> wellDataDatabaseContainer "reads/writes"
                winsWatchdogContainer -> wellDataDatabaseContainer "reads"
                winsWatchdogContainer -> winsProcessorContainer "reads"
                winsWatchdogContainer -> winsServerContainer "reads"
            }

            orleansSystem = softwareSystem "Orleans Cluster" "Orleans"{
                orleansContainer = container "Orleans grains container"
                orleansDatabaseContainer = container "OrleansDatabase" "DataBase for orleans" "SQL Server Database Schema" "Database"
                orleansContainer -> orleansDatabaseContainer "Reads/Writes Data"
            }

            facadeSystem = softwareSystem "WellboreFacade" "WellBore Facade"{
                wellboreFacadeContainer = container "WellBoreFacade" "C#" "WebServer" "New"
                rigSenseFacadePluginContainer = container "RigSensePlugin" "C#" "Plugin" "New"
                welldataFacadePluginContainer = container "WellDataPlugin" "C#" "Plugin" "New"
            }

            accessNOVSystem = softwareSystem "Access NOV" "AccessNOV"{
                welldataMaxContainer = container "WellDataMax" "WellData Max App" "Beta App" "New"
            }

            drillWellSystem = softwareSystem "DrillWell" "DrillWell/PetroSynergy/Synopsis"

        }

        // rigsense
            //software systems users
        rigUser -> rigSenseSystem "Uses RigSense"

            // software containers users
        rigUser -> pipeTallyClientContainer "uses PipeTally"
        rigUser -> RMSClientContainer "uses RMS"
        rigUser -> edrClientContainer "uses EDRControls"
        rigUser -> rigSenseAccessNOVClientContainer "uses WellData"

            //containers relationships
        edrClientContainer -> configurationServicesContainer "subscribes to config"
        edrClientContainer -> channelDataServicesContainer "subscribes to channel Data"
        edrClientContainer -> wcfServicesContainer "subscribes to channel Data"
        RMSClientContainer -> rmsServerContainer "subscribes to RMS Data"
        pipeTallyClientContainer -> pipeTallyServer "subscribes to PipeTally Data"
        wellDataUploaderContainer -> wellDataServicesContainer "sends files"
        rigSenseAccessNOVClientContainer -> welldataMaxContainer "loads WellData"
        

            // containers relationship
        dataSourcesContainer -> dataSourceServicesContainer "publishes data"
        channelDataServicesContainer -> databaseContainer "Writes to"
        rmsServerContainer -> databaseContainer "reads/writes"
        backupServicesContainer -> databaseContainer "reads"
        pipeTallyServer -> webRTServerContainer "reads"
        configurationServicesContainer -> webRTServerContainer "updates"
        channelDataServicesContainer -> webRTServerContainer "updates"
        rigSenseConfigToolContainer -> configurationServicesContainer "updates"
        witsmlContainer -> configurationServicesContainer "subscribes to"
        witsmlContainer -> channelDataServicesContainer "subscribes to"
        witsmlContainer -> thirdPartyDatabaseContainer "stores/retrieves"
        wcfServicesContainer -> TnDDatabaseContainer "stores/retrievs"
        channelDataServicesContainer -> dataSourceServicesContainer "subscribes to"
        novConnectBackupServicesContainer -> databaseContainer "reads"
            //NOV Connect to WellData
        novConnectBackupServicesContainer -> winsClientContainer "sends to"
        winsClientContainer -> winsServerContainer "sends to"
        wellDataRTContainer -> webRTServerContainer "reads/writes"
        welldataAccessNOVClientContainer -> welldataMaxContainer "loads"
        welldataAccessNOVClientContainer -> wellDataRestAPIContainer "reads/writes"
        welldataAccessNOVClientContainer -> wellboreFacadeContainer "reads/writes"

        // welldata users
        officeUser -> wellDataClientSystems "uses Welldata"
        officeUser -> UVRTClientContainer "uses WelldataRT"
        officeUser -> MobileRTClientContainer "uses MobileRT"
        officeUser -> wellDataWebClientContainer "uses WellData"
        officeUser -> welldataAccessNOVClientContainer "uses Welldata"

        emailprovider -> officeUser "Sends data/reports" "E-mail message" "Asynchronous"

        //rigsense relationships
        rigSenseSystem -> novConnectSystem "provide real time data"
        novConnectSystem -> wellDataSystem "Sends Data to WellData"


        //welldata client relationships
        wellDataWebClientContainer -> wellDataWebSiteContainer "reads/writes"
        UVRTClientContainer -> wellDataRTContainer "reads/writes"
        MobileRTClientContainer -> wellDataRTContainer "reads/writes"
        MobileRTClientContainer -> wellDataRestAPIContainer "reads/writes"
        officeUser -> SFTPServer "send employee lists"
        SFTPServer -> winsClientContainer "sends employee lists"

        //welldata relationships
        wellDataEXContainer -> emailprovider "sends to"
        wellDataEXContainer -> customerFTPServer "sends to"
        wellDataEXContainer -> customerSFTPServer "sends to"
        orleansContainer -> MobileRTClientContainer "sends notifications"
        wellDataRTContainer -> orleansContainer "provides real time data"

        //accessNOV relationships
        //welldataMaxContainer -> welldataRestAPIContainer "reads/writes"
        rigSenseAccessNOVClientContainer -> wellboreFacadeContainer "reads/writes"

        //facade relationships
        wellboreFacadeContainer -> rigSenseFacadePluginContainer "Loads"
        wellboreFacadeContainer -> welldataFacadePluginContainer "Loads"
        rigSenseFacadePluginContainer -> dataSourcesContainer "reads/writes" "grpc"
        welldataFacadePluginContainer -> wellDataRTContainer "subscribes" "WRQ"
        welldataFacadePluginContainer -> wellDataDatabaseContainer "reads/writes" "grpc"
    }
         
    views {

        //overall diagram
        systemLandscape "WellDataSystem" "WellData Overview" {
            include *
            autoLayout
        }

        //rigsense diagrams
        systemContext rigSenseSystem "RigSenseContext" "Test 1" {
            include *
            autoLayout
        }

        container rigSenseSystem "RigSenseOverviewContainers" {
            include *
            autoLayout
        }

        container rigSenseSystem "RigSensePre-HybridContainers" {
            include edrClientContainer RMSClientContainer rmsServerContainer pipeTallyClientContainer pipeTallyServer channelDataServicesContainer databaseContainer dataSourcesContainer dataSourceServicesContainer webRTServerContainer winsClientContainer novConnectBackupServicesContainer rigUser
            autoLayout
        }

        container wellDataSystem "WellDataPre-HybridContainers" {
            include officeUser welldataMaxContainer wellDataWebClientContainer wellDataWebSiteContainer UVRTClientContainer MobileRTClientContainer wellDataRTContainer wellDataRestAPIContainer wellDataWebSiteContainer wellDataDatabaseContainer wellDataRTDatabaseContainer
            autoLayout
        }

        container rigSenseSystem "RigSenseWellDataPre-HybridContainers" {
            include edrClientContainer RMSClientContainer rmsServerContainer pipeTallyClientContainer pipeTallyServer channelDataServicesContainer databaseContainer dataSourcesContainer dataSourceServicesContainer webRTServerContainer rigUser officeUser wellDataWebClientContainer wellDataWebSiteContainer winsClientContainer winsServerContainer UVRTClientContainer MobileRTClientContainer wellDataRTContainer wellDataRestAPIContainer wellDataWebSiteContainer wellDataDatabaseContainer wellDataRTDatabaseContainer welldataMaxContainer
            autoLayout
        }

        container rigSenseSystem "RigSensePost-HybridContainers" {
            include edrClientContainer RMSClientContainer rmsServerContainer pipeTallyClientContainer pipeTallyServer channelDataServicesContainer databaseContainer dataSourcesContainer dataSourceServicesContainer webRTServerContainer winsClientContainer novConnectBackupServicesContainer rigUser wellboreFacadeContainer rigSenseFacadePluginContainer welldataFacadePluginContainer welldataMaxContainer rigSenseAccessNOVClientContainer
            exclude welldataFacadePluginContainer
            autoLayout
        }

        container wellDataSystem "WellDataPost-HybridContainers" {
            include officeUser welldataMaxContainer wellDataWebClientContainer wellDataWebSiteContainer UVRTClientContainer MobileRTClientContainer wellDataRTContainer wellDataRestAPIContainer wellDataWebSiteContainer wellDataDatabaseContainer wellDataRTDatabaseContainer wellboreFacadeContainer rigSenseFacadePluginContainer welldataFacadePluginContainer welldataMaxContainer welldataAccessNOVClientContainer
            exclude rigSenseFacadePluginContainer
            exclude welldataMaxContainer -> wellDataRestAPIContainer
            autoLayout
        }

        container rigSenseSystem "RigSenseWellDataPost-HybridContainers" {
            include edrClientContainer RMSClientContainer rmsServerContainer pipeTallyClientContainer pipeTallyServer channelDataServicesContainer databaseContainer dataSourcesContainer dataSourceServicesContainer webRTServerContainer rigUser officeUser wellDataWebClientContainer wellDataWebSiteContainer winsClientContainer winsServerContainer UVRTClientContainer MobileRTClientContainer wellDataRTContainer wellDataRestAPIContainer wellDataWebSiteContainer wellDataDatabaseContainer wellDataRTDatabaseContainer welldataMaxContainer wellboreFacadeContainer rigSenseFacadePluginContainer welldataFacadePluginContainer welldataMaxContainer
            autoLayout
        }

        container novConnectSystem "NOVConnectContainers" {
            include *
            autoLayout
        }

        //wellData diagrams
        container wellDataSystem "WellDataContext" {
            include *
            autoLayout
        }
        container wellDataClientSystems "WellDataClientContext" {
            include *
            autoLayout
        }

        container accessNOVSystem "AccessNOVContext" {
            include *
            autoLayout
        }

        styles {
            element "Element" {
                color #ffffff
                background #5B9BD5
            }
            element "Software System" {
                background #801515
                shape RoundedBox
            }
            element "WellData System" {
                background #550000
                color #ffffff
            }

            element "Future State" {
                opacity 30
            }
            element "Person" {
                background #d46a6a
                shape Person
            }
            relationship "Relationship" {
                dashed false
            }
            relationship "Asynchronous" {
                dashed true
            }
            relationship "Alert" {
                color #ff0000
            }
            relationship "Future State" {
                opacity 30
            }
            element "Database" {
                shape Cylinder
                background #5B9BD5
            }

            element "Folder" {
                shape Folder
                background #5B9BD5
            }

            element "Printer" {
                shape Robot
                background #5B9BD5
            }

            element "WebBrowser" {
                shape WebBrowser
                background #5B9BD5
            }
            element "MobileDevicePortrait" {
                shape MobileDeviceLandscape
                background #5B9BD5
            }

            element "New" {
                background #d46a6a
            }

       }
    }
}
