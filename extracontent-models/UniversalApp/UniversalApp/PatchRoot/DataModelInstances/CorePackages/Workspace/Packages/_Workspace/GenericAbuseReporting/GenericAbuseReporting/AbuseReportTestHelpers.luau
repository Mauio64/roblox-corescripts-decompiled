local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local RoactServices = require(GenericAbuseReportingParent.RoactServices).RoactServices
local LoaderContext = require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local MockProviders = require(GenericAbuseReporting.MockProviders)
local LoaderProvider = LoaderContext.LoaderProvider

local function findEventsBySubType(p1, s1: string, p2: ((...any) -> ...any)?) -- line: 109
	local t1 = {}

	for _, v18 in p1.mock.calls do
		local v19 = v18[2]

		if v19 and s1 == v19.sub_event_type and (p2 == nil or p2(v19)) then
			table.insert(t1, v18)
		end
	end

	return t1
end

return {
	wrapInAbuseReportProviders = function(p3, t2: {[any]: any}?) -- line: 19
		-- upvalues: React (copy), RoactServices (copy), RoactNetworking (copy), MockProviders (copy), LoaderProvider (copy)
		local v12 = t2 or {}

		return React.createElement(RoactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = v12.networkImpl or {}
			}
		}, {
			Providers = React.createElement(MockProviders, nil, {
				LoaderCtx = React.createElement(LoaderProvider, {
					loaders = v12.loaders or {},
					open = v12.loaderOpen == nil or v12.loaderOpen
				}, {
					Child = p3
				})
			})
		})
	end,
	makeMinimalCloseConfig = function() -- line: 39
		return {
			version = 1,
			resources = {},
			attributes = {},
			display = {
				closeButtonLabel = "Close"
			},
			nodes = {
				root = {
					type = "paragraph",
					title = "Root",
					paragraph = "Root paragraph",
					nextButtonText = "Continue",
					next = {
						type = "close"
					}
				}
			},
			translations = {}
		}
	end,
	makeListParagraphConfig = function() -- line: 60
		return {
			name = "test_list_paragraph",
			version = 1,
			resources = {},
			attributes = {},
			submission = {
				endpoint = "test",
				data = {
					abuseVector = "test",
					targetIdStr = "test",
					category = "test",
					comment = "test",
					targetType = "user"
				}
			},
			display = {
				closeButtonLabel = "Close"
			},
			nodes = {
				root = {
					type = "list",
					eyebrow = "Report",
					title = "Select an option",
					formKey = "test",
					nextButtonText = "Continue",
					items = {{
						id = "test",
						label = "TestItem1"
					}},
					next = {
						type = "close"
					}
				}
			},
			translations = {}
		}
	end,
	makeMalformedConfig = function() -- line: 96
		return {
			version = 1,
			resources = {},
			attributes = {},
			display = {
				closeButtonLabel = "Close"
			},
			nodes = {},
			translations = {}
		}
	end,
	findEventsBySubType = findEventsBySubType,
	findRenderErrorEvents = function(p4) -- line: 126
		-- upvalues: findEventsBySubType (copy)
		return (findEventsBySubType(p4, "Error", function(p5) -- line: 127
			local v23 = p5.error_detail and p5.error_detail.error_message

			return type(v23) == "string" and v23:sub(1, 13) == "Render error:"
		end))
	end,
	findFetchErrorEvents = function(p6) -- line: 133
		-- upvalues: findEventsBySubType (copy)
		return (findEventsBySubType(p6, "Error", function(p7) -- line: 134
			local v25 = p7.error_detail and p7.error_detail.error_message

			return type(v25) == "string" and v25:sub(1, 23) == "Failed to fetch config:"
		end))
	end
}
