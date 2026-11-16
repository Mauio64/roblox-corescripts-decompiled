local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local SharedFlags = require(parent.SharedFlags)
local t = require(parent.t)

local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

local v = {
	componentType = t.literal("dropdown"),
	isOptional = t.boolean,
	formDataKey = t.string,
	requirementMessage = t.string,
	dropdown = t.interface({
		prompt = t.string,
		placeholder = t.string,
		items = t.array(t.interface({
			label = t.string,
			formDataValue = t.union(t.number, t.string)
		}))
	})
}

local v2 = {
	componentType = t.literal("freeComment"),
	isOptional = t.boolean,
	formDataKey = t.string,
	requirementMessage = t.string,
	freeComment = t.interface({ prompt = t.string, placeholder = t.string })
}

local v3 = {
	componentType = t.literal("paragraph"),
	isOptional = t.boolean,
	formDataKey = t.optional(t.string),
	paragraph = t.interface({
		text = t.string,
		links = t.optional(t.map(
			t.string,
			t.interface({ label = t.string, linkButtonLabel = t.string, url = t.string })
		))
	})
}

local v4 = {
	componentType = t.literal("selector"),
	isOptional = t.boolean,
	formDataKey = t.string,
	requirementMessage = t.string,
	selector = t.interface({ prompt = t.string })
}

local v5 = {
	componentType = t.literal("link"),
	isOptional = t.boolean,
	formDataKey = t.optional(t.string),
	link = t.interface({ label = t.string, linkButtonLabel = t.string, url = t.string })
}

local v6 = {
	type = t.literal("configurableComponentList"),
	configurableComponentList = 0
}
local interface = t.interface
local components

if FFlagAddThumbnailSelectorReport then
	components = t.array(t.union(t.interface(v), t.interface(v2), t.interface(v3), t.interface(v4), t.interface(v5)))
else
	components = t.array(t.union(t.interface(v), t.interface(v2), t.interface(v3), t.interface(v5)))
end

v6.configurableComponentList = interface({ components = components })

local union = t.union(t.interface(v6))

local v7 = {
	title = t.string,
	subtitle = t.string,
	actionInfo = t.interface({
		actionLabel = t.optional(t.string),
		predefinedNextStepId = t.number,
		shouldSubmit = t.optional(t.boolean)
	}),
	stepId = t.number,
	internalStepName = t.string,
	isCompletionStep = t.optional(t.boolean),
	innerContentConfig = t.optional(union),
	footerContentConfig = t.optional(union)
}

return {
	AbuseReportBeduiContextStatus = { Loading = "Loading", Success = "Success", Error = "Error" },
	BeduiDataTypeInterface = { rootStepId = t.number, nodes = t.array(t.interface(v7)) },
	ComponentType = {
		Dropdown = "dropdown",
		FreeComment = "freeComment",
		Paragraph = "paragraph",
		Selector = FFlagAddThumbnailSelectorReport and "selector" or nil,
		WebViewLink = "link"
	},
	ContentConfigType = {
		InnerContentConfig = "innerContentConfig",
		FooterContentConfig = "footerContentConfig"
	},
	InnerContentConfigType = { ConfigurableComponentList = "configurableComponentList" },
	NotificationType = { OpenCustomWebView = 20 }
}
