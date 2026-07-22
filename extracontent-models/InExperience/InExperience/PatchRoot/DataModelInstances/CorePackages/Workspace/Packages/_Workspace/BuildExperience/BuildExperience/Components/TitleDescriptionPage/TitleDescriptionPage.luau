local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local TextArea = Foundation.TextArea
local TextInput = Foundation.TextInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function TitleDescriptionPage(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), GameConfigurationActions (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy), LocalizationStrings (copy), TextInput (copy), TextArea (copy)
	local v17 = t1.testId or "title-description-page"
	local v18 = t1.titleText or ""
	local v19 = t1.descriptionText or ""
	local v20, v21 = React.useBinding(v18)
	local v22, v23 = React.useBinding(v19)
	local v24 = React.useCallback(function() -- line: 39
		-- upvalues: t1 (copy), v20 (copy), v22 (copy), v18 (copy), v19 (copy), GameConfigurationActions (copy)
		local universeId = t1.universeId

		if universeId == nil then
			return
		end

		local v27 = v20:getValue()
		local v28 = v22:getValue()

		if v27 == v18 and v28 == v19 then
			return
		end

		GameConfigurationActions.updateTitleDescription(universeId, v27, v28):catch(function(p1) -- line: 52
			warn(`[BuildExperience] Failed to save title and description: { tostring(p1) }`)
		end)
	end, {
		v22,
		v19,
		v18,
		t1.universeId,
		v20
	})

	React.useEffect(function() -- line: 65
		-- upvalues: v24 (copy)
		return v24
	end, { v24 })

	local v25 = React.useCallback(function() -- line: 69
		-- upvalues: v24 (copy), t1 (copy)
		v24()
		t1.onBack()
	end, {
		t1.onBack,
		v24
	})

	return React.createElement(View, {
		tag = "col align-x-center size-full bg-surface-0",
		LayoutOrder = t1.layoutOrder,
		testId = v17
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
			testId = `{ v17 }-header`
		}, {
			Back = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = IconName.ArrowLargeLeft,
				onActivated = v25,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility,
				testId = `{ v17 }-back`
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
				Text = LocalizationStrings.TITLE_DESCRIPTION_TITLE
			})
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = "composition-content-body col gap-xlarge size-full-0 auto-y padding-y-large",
			testId = `{ v17 }-content-body`
		}, {
			TitleInput = React.createElement(TextInput, {
				LayoutOrder = 1,
				label = LocalizationStrings.TITLE_DESCRIPTION_TITLE_LABEL,
				placeholder = t1.titlePlaceholder,
				text = v20,
				width = UDim.new(1, 0),
				onChanged = v21,
				onFocusLost = v24,
				testId = `{ v17 }-title-input`
			}),
			DescriptionInput = React.createElement(TextArea, {
				LayoutOrder = 2,
				numLines = 4,
				label = LocalizationStrings.TITLE_DESCRIPTION_DESCRIPTION_LABEL,
				placeholder = t1.descriptionPlaceholder,
				text = v22,
				width = UDim.new(1, 0),
				onChanged = v23,
				onFocusLost = v24,
				testId = `{ v17 }-description-input`
			})
		})
	})
end

return TitleDescriptionPage
