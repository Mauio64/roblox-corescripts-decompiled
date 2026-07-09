local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
local AbuseReportBeduiContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiContext)
local AbuseReportBeduiContextStatus = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes).AbuseReportBeduiContextStatus
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local fetchBeduiData = require(GenericAbuseReporting.Bedui.Provider.fetchBeduiData)
local validateBeduiData = require(GenericAbuseReporting.Bedui.Provider.validateBeduiData)
local v11 = game:DefineFastFlag("FallbackGenericAbuseReporting", false)

local function AbuseReportBeduiProvider(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), AbuseReportBeduiContextStatus (copy), useRoactService (copy), RoactNetworking (copy), fetchBeduiData (copy), validateBeduiData (copy), v11 (copy), AbuseVector (copy), AbuseReportBeduiContext (copy)
	local v14, v15 = React.useState({
		status = AbuseReportBeduiContextStatus.Loading
	})
	local v16 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 41
		-- upvalues: fetchBeduiData (copy), v16 (copy), t1 (copy), validateBeduiData (copy), v11 (copy), AbuseVector (copy), v15 (copy), AbuseReportBeduiContextStatus (copy)
		fetchBeduiData(v16, t1.abuseVector):andThen(function(p1) -- line: 43
			-- upvalues: validateBeduiData (copy), v11 (copy), fetchBeduiData (copy), v16 (copy), AbuseVector (copy), v15 (copy), AbuseReportBeduiContextStatus (copy)
			local v18, v19 = validateBeduiData(p1.responseBody)

			if not v18 then
				warn("Invalid Bedui data:", v19)

				if v11 then
					fetchBeduiData(v16, AbuseVector.Common):andThen(function(p2) -- line: 51
						-- upvalues: validateBeduiData (copy), v15 (copy), AbuseReportBeduiContextStatus (copy)
						local v22, v23 = validateBeduiData(p2.responseBody)

						if not v22 then
							warn("Invalid Bedui common data:", v23)
							v15({
								status = AbuseReportBeduiContextStatus.Error,
								error = v23
							})

							return
						end

						v15({
							status = AbuseReportBeduiContextStatus.Success,
							beduiData = p2.responseBody
						})
					end):catch(function(p3) -- line: 67
						-- upvalues: v15 (copy), AbuseReportBeduiContextStatus (copy)
						warn("Failed to get Bedui common data")
						v15({
							status = AbuseReportBeduiContextStatus.Error,
							error = p3
						})
					end)

					return
				end

				v15({
					status = AbuseReportBeduiContextStatus.Error,
					error = v19
				})

				return
			end

			v15({
				status = AbuseReportBeduiContextStatus.Success,
				beduiData = p1.responseBody
			})
		end):catch(function(p4) -- line: 87
			-- upvalues: v15 (copy), AbuseReportBeduiContextStatus (copy)
			warn("Failed to get Bedui data")
			v15({
				status = AbuseReportBeduiContextStatus.Error,
				error = p4
			})
		end)
	end, { t1.abuseVector })

	return React.createElement(AbuseReportBeduiContext.Provider, {
		value = v14
	}, t1.children)
end

return AbuseReportBeduiProvider
