local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local TextArea = Foundation.TextArea
local TextInput = Foundation.TextInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function TitleDescriptionPage(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), GameConfigurationActions (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy), TextInput (copy), TextArea (copy)
	local v16 = t1.testId or "title-description-page"
	local v17 = t1.titleText or ""
	local v18 = t1.descriptionText or ""
	local v19, v20 = React.useBinding(v17)
	local v21, v22 = React.useBinding(v18)
	local v23 = React.useCallback(function() -- line: 38
		-- upvalues: t1 (copy), v19 (copy), v21 (copy), v17 (copy), v18 (copy), GameConfigurationActions (copy)
		local universeId = t1.universeId

		if universeId == nil then
			return
		end

		local v26 = v19:getValue()
		local v27 = v21:getValue()

		if v26 == v17 and v27 == v18 then
			return
		end

		GameConfigurationActions.updateTitleDescription(universeId, v26, v27):catch(function(p1) -- line: 51
			warn(`[BuildExperience] Failed to save title and description: { tostring(p1) }`)
		end)
	end, {
		v21,
		v18,
		v17,
		t1.universeId,
		v19
	})

	React.useEffect(function() -- line: 64
		-- upvalues: v23 (copy)
		return v23
	end, { v23 })

	local v24 = React.useCallback(function() -- line: 68
		-- upvalues: v23 (copy), t1 (copy)
		v23()
		t1.onBack()
	end, {
		t1.onBack,
		v23
	})

	return React.createElement(View, {
		tag = "col align-x-center size-full bg-surface-0",
		LayoutOrder = t1.layoutOrder,
		testId = v16
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
			testId = `{ v16 }-header`
		}, {
			Back = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = IconName.ArrowLargeLeft,
				onActivated = v24,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility,
				testId = `{ v16 }-back`
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = "Title & Description",
				tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis"
			})
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = "composition-content-body col gap-xlarge size-full-0 auto-y padding-y-large",
			testId = `{ v16 }-content-body`
		}, {
			TitleInput = React.createElement(TextInput, {
				LayoutOrder = 1,
				label = "Title",
				placeholder = t1.titlePlaceholder,
				text = v19,
				width = UDim.new(1, 0),
				onChanged = v20,
				onFocusLost = v23,
				testId = `{ v16 }-title-input`
			}),
			DescriptionInput = React.createElement(TextArea, {
				LayoutOrder = 2,
				label = "Description",
				numLines = 4,
				placeholder = t1.descriptionPlaceholder,
				text = v21,
				width = UDim.new(1, 0),
				onChanged = v22,
				onFocusLost = v23,
				testId = `{ v16 }-description-input`
			})
		})
	})
end

return TitleDescriptionPage
