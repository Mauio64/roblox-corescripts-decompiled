local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local Avatar = Foundation.Avatar
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local useExperienceDetails = require(GenericAbuseReporting.BeduiV2.Hooks.Enrichment.useExperienceDetails)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

local function UserPreview(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), Avatar (copy), FoundationText (copy)
	local preview = t1.preview

	if not preview then
		return nil
	end

	return React.createElement(View, {
		tag = "row size-full-0 auto-y gap-medium radius-medium bg-surface-200 padding-medium align-y-center",
		LayoutOrder = t1.layoutOrder
	}, {
		Avatar = preview.id ~= nil and React.createElement(Avatar, {
			LayoutOrder = 1,
			userId = tonumber(preview.id)
		}),
		TextContainer = (preview.displayName or preview.username) and React.createElement(View, {
			tag = "col auto-xy fill",
			LayoutOrder = 2
		}, {
			DisplayName = preview.displayName and React.createElement(FoundationText, {
				RichText = true,
				tag = "auto-xy content-emphasis text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = preview.displayName
			}),
			Username = preview.username and React.createElement(FoundationText, {
				RichText = true,
				tag = "auto-xy text-wrap text-align-x-left",
				LayoutOrder = 2,
				Text = "@" .. preview.username
			})
		})
	})
end
local function ChatPreview(t2: {[any]: any}) -- line: 60
	-- upvalues: React (copy), View (copy), TextWithTranslation (copy)
	local preview = t2.preview

	if not preview then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y gap-xsmall radius-medium bg-surface-200 padding-medium",
		LayoutOrder = t2.layoutOrder
	}, {
		Message = React.createElement(TextWithTranslation, {
			tag = "auto-xy text-wrap text-align-x-left",
			input = preview.text
		})
	})
end
local function ExperiencePreview(t3: {[any]: any}) -- line: 77
	-- upvalues: useExperienceDetails (copy), React (copy), View (copy), FoundationImage (copy), FoundationText (copy)
	local preview = t3.preview
	local v21 = useExperienceDetails(preview.id)

	if not preview then
		return nil
	end

	return React.createElement(View, {
		tag = "row size-full-0 auto-y gap-medium radius-medium bg-surface-200 padding-medium align-y-center",
		LayoutOrder = t3.layoutOrder
	}, {
		ExperienceIcon = React.createElement(FoundationImage, {
			tag = "radius-medium",
			Image = `rbxthumb://type=GameIcon&id={ preview.id }&w=50&h=50`,
			Size = UDim2.fromOffset(40, 40)
		}),
		Name = React.createElement(FoundationText, {
			RichText = true,
			tag = "auto-xy text-wrap text-align-x-left",
			Text = v21 and v21.name or (preview.title or "")
		})
	})
end
local function PreviewBox(t4: {[any]: any}) -- line: 104
	-- upvalues: React (copy), UserPreview (copy), ChatPreview (copy), ExperiencePreview (copy)
	local preview = t4.preview

	if preview.type == "user" then
		return React.createElement(UserPreview, {
			preview = preview,
			layoutOrder = t4.layoutOrder
		})
	end

	if preview.type == "chat" then
		return React.createElement(ChatPreview, {
			preview = preview,
			layoutOrder = t4.layoutOrder
		})
	end

	if preview.type == "experience" then
		return React.createElement(ExperiencePreview, {
			preview = preview,
			layoutOrder = t4.layoutOrder
		})
	end

	return nil
end

return React.memo(PreviewBox)
