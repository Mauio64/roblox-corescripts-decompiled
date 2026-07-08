local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local SharedFlags = require(Parent.SharedFlags)
local t = require(Parent.t)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local t1 = {
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
local t2 = {
	componentType = t.literal("freeComment"),
	isOptional = t.boolean,
	formDataKey = t.string,
	requirementMessage = t.string,
	freeComment = t.interface({
		prompt = t.string,
		placeholder = t.string
	})
}
local t3 = {
	componentType = t.literal("paragraph"),
	isOptional = t.boolean,
	formDataKey = t.optional(t.string),
	paragraph = t.interface({
		text = t.string,
		links = t.optional(t.map(t.string, t.interface({
			label = t.string,
			linkButtonLabel = t.string,
			url = t.string
		})))
	})
}
local t4 = {
	componentType = t.literal("selector"),
	isOptional = t.boolean,
	formDataKey = t.string,
	requirementMessage = t.string,
	selector = t.interface({
		prompt = t.string
	})
}
local t5 = {
	componentType = t.literal("link"),
	isOptional = t.boolean,
	formDataKey = t.optional(t.string),
	link = t.interface({
		label = t.string,
		linkButtonLabel = t.string,
		url = t.string
	})
}
local t6 = {
	type = t.literal("configurableComponentList"),
	configurableComponentList = t.interface({
		components = if not FFlagAddThumbnailSelectorReport then t.array(t.union(t.interface(t1), t.interface(t2), t.interface(t3), t.interface(t5))) else t.array(t.union(t.interface(t1), t.interface(t2), t.interface(t3), t.interface(t4), t.interface(t5)))
	})
}
local v11 = t.union(t.interface(t6))
local t7 = {
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
	innerContentConfig = t.optional(v11),
	footerContentConfig = t.optional(v11)
}
local t8 = {
	rootStepId = t.number,
	nodes = t.array(t.interface(t7))
}

return {
	AbuseReportBeduiContextStatus = {
		Loading = "Loading",
		Success = "Success",
		Error = "Error"
	},
	BeduiDataTypeInterface = t8,
	ComponentType = {
		Dropdown = "dropdown",
		FreeComment = "freeComment",
		Paragraph = "paragraph",
		WebViewLink = "link",
		Selector = if not FFlagAddThumbnailSelectorReport then nil else "selector"
	},
	ContentConfigType = {
		InnerContentConfig = "innerContentConfig",
		FooterContentConfig = "footerContentConfig"
	},
	InnerContentConfigType = {
		ConfigurableComponentList = "configurableComponentList"
	},
	NotificationType = {
		OpenCustomWebView = 20
	}
}
