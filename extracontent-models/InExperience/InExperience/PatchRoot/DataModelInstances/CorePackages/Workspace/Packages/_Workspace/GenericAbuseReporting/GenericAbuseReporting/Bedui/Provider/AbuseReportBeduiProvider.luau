local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local AbuseReportBeduiContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiContext)
local AbuseReportBeduiTypes = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local AbuseReportBeduiContextStatus = AbuseReportBeduiTypes.AbuseReportBeduiContextStatus
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local fetchBeduiData = require(GenericAbuseReporting.Bedui.Provider.fetchBeduiData)
local validateBeduiData = require(GenericAbuseReporting.Bedui.Provider.validateBeduiData)

local function AbuseReportBeduiProvider(p)
	local state, setState = React.useState({ status = AbuseReportBeduiContextStatus.Loading })

	local v = useRoactService(RoactNetworking)

	React.useEffect(function()
		fetchBeduiData(v, p.abuseVector):andThen(function(p2)
			local v2, v3 = validateBeduiData(p2.responseBody)

			if v2 then
				setState({
					status = AbuseReportBeduiContextStatus.Success,
					beduiData = p2.responseBody
				})

				return
			end

			warn("Invalid Bedui data:", v3)

			fetchBeduiData(v, AbuseVector.Common):andThen(function(p3)
				local v4, err = validateBeduiData(p3.responseBody)

				if v4 then
					setState({
						status = AbuseReportBeduiContextStatus.Success,
						beduiData = p3.responseBody
					})

					return
				end

				warn("Invalid Bedui common data:", err)
				setState({ status = AbuseReportBeduiContextStatus.Error, error = err })
			end):catch(function(err)
				warn("Failed to get Bedui common data")
				setState({ status = AbuseReportBeduiContextStatus.Error, error = err })
			end)
		end):catch(function(err)
			warn("Failed to get Bedui data")
			setState({ status = AbuseReportBeduiContextStatus.Error, error = err })
		end)
	end, { p.abuseVector })

	return React.createElement(AbuseReportBeduiContext.Provider, { value = state }, p.children)
end

return AbuseReportBeduiProvider
