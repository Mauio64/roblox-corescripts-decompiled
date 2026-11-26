local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/t")

local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

local v5 = {
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

local v6 = {
	componentType = t.literal("freeComment"),
	isOptional = t.boolean,
	formDataKey = t.string,
	requirementMessage = t.string,
	freeComment = t.interface({
		prompt = t.string,
		placeholder = t.string
	})
}

local v7 = {
	componentType = t.literal("paragraph"),
	isOptional = t.boolean,
	formDataKey = t.optional(t.string),
	paragraph = t.interface({
		text = t.string,
		links = t.optional(t.map(
			t.string,
			t.interface({
				label = t.string,
				linkButtonLabel = t.string,
				url = t.string
			})
		))
	})
}

local v8 = {
	componentType = t.literal("selector"),
	isOptional = t.boolean,
	formDataKey = t.string,
	requirementMessage = t.string,
	selector = t.interface({ prompt = t.string })
}

local v9 = {
	componentType = t.literal("link"),
	isOptional = t.boolean,
	formDataKey = t.optional(t.string),
	link = t.interface({
		label = t.string,
		linkButtonLabel = t.string,
		url = t.string
	})
}

local v10 = {
	type = t.literal("configurableComponentList"),
	configurableComponentList = 0
}
local interface = t.interface

local v12 = if fFlagAddThumbnailSelectorReport then t.array(t.union(
	t.interface(v5),
	t.interface(v6),
	t.interface(v7),
	t.interface(v8),
	t.interface(v9)
)) else t.array(t.union(
	t.interface(v5),
	t.interface(v6),
	t.interface(v7),
	t.interface(v9)
))
v10.configurableComponentList = interface({ components = v12 })

local union = t.union(t.interface(v10))

local v13 = {
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
	AbuseReportBeduiContextStatus = {
		Loading = "Loading",
		Success = "Success",
		Error = "Error"
	},
	BeduiDataTypeInterface = {
		rootStepId = t.number,
		nodes = t.array(t.interface(v13))
	},
	ComponentType = {
		Dropdown = "dropdown",
		FreeComment = "freeComment",
		Paragraph = "paragraph",
		Selector = fFlagAddThumbnailSelectorReport and "selector" or nil,
		WebViewLink = "link"
	},
	ContentConfigType = {
		InnerContentConfig = "innerContentConfig",
		FooterContentConfig = "footerContentConfig"
	},
	InnerContentConfigType = { ConfigurableComponentList = "configurableComponentList" },
	NotificationType = { OpenCustomWebView = 20 }
}
