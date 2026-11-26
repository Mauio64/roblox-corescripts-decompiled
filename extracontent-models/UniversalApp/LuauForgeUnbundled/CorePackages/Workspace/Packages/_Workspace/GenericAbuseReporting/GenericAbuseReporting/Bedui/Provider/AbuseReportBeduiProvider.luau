local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

local AbuseReportBeduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiContext")
local abuseReportBeduiContextStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes").AbuseReportBeduiContextStatus
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local fetchBeduiData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/fetchBeduiData")
local validateBeduiData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/validateBeduiData")

local function AbuseReportBeduiProvider(p2)
	local state, setState = React.useState({
		status = abuseReportBeduiContextStatus.Loading
	})

	local v5 = useRoactService(roactNetworking)

	React.useEffect(function()
		fetchBeduiData(v5, p2.abuseVector):andThen(function(p3)
			local v6, v7 = validateBeduiData(p3.responseBody)

			if v6 then
				setState({
					status = abuseReportBeduiContextStatus.Success,
					beduiData = p3.responseBody
				})

				return
			end

			warn("Invalid Bedui data:", v7)

			fetchBeduiData(v5, AbuseVector.Common):andThen(function(p4)
				local v8, v9 = validateBeduiData(p4.responseBody)

				if v8 then
					setState({
						status = abuseReportBeduiContextStatus.Success,
						beduiData = p4.responseBody
					})

					return
				end

				warn("Invalid Bedui common data:", v9)
				setState({ status = abuseReportBeduiContextStatus.Error, error = v9 })
			end):catch(function(p4)
				warn("Failed to get Bedui common data")
				setState({ status = abuseReportBeduiContextStatus.Error, error = p4 })
			end)
		end):catch(function(p3)
			warn("Failed to get Bedui data")
			setState({ status = abuseReportBeduiContextStatus.Error, error = p3 })
		end)
	end, { p2.abuseVector })

	return React.createElement(AbuseReportBeduiContext.Provider, { value = state }, p2.children)
end

return AbuseReportBeduiProvider
