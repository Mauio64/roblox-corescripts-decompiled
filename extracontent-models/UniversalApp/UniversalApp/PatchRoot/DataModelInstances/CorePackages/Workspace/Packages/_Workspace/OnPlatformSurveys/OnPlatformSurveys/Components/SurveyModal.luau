local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local FocusNavigationUtils = require(OnPlatformSurveysParent.FocusNavigationUtils)
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local DialogSize = Foundation.Enums.DialogSize
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue
local useSurveyFocusRefs = require(OnPlatformSurveys.Hooks.useSurveyFocusRefs)

local function SurveyModal(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), useScaledValue (copy), useSurveyFocusRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), Sheet (copy), DialogSize (copy), FoundationText (copy), View (copy)
	local v15 = t1.isOpen ~= false
	local onClose = t1.onClose
	local v17, v18 = React.useState(0)
	local v19, v20 = React.useState(0)
	local v21 = React.useCallback(function(p1) -- line: 35
		-- upvalues: v18 (copy)
		v18(p1.AbsoluteSize.Y)
	end, {})
	local v22 = React.useCallback(function(p2) -- line: 38
		-- upvalues: v20 (copy)
		v20(p2.AbsoluteSize.Y)
	end, {})
	local v23 = useScaledValue(116)
	local v24 = (not t1.children and 0 or v17) + v23 + (not t1.footer and 0 or v19)
	local v25 = React.useMemo(function() -- line: 47
		-- upvalues: v24 (copy)
		return { v24 }
	end, { v24 })
	local v26 = useSurveyFocusRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, onClose)

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		isOpen = v15,
		onClose = onClose,
		size = DialogSize.Large,
		centerSheetHeight = v24,
		snapPoints = v25,
		ref = v26
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = t1.title and React.createElement(FoundationText, {
				tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
				Text = t1.title
			}) or nil
		}),
		Content = React.createElement(Sheet.Content, {}, {
			Body = React.createElement(View, {
				tag = "col size-full-0 auto-y padding-bottom-small",
				onAbsoluteSizeChanged = v21
			}, t1.children)
		}),
		Actions = t1.footer and React.createElement(Sheet.Actions, {}, {
			Footer = React.createElement(View, {
				tag = "row size-full-0 auto-y",
				onAbsoluteSizeChanged = v22
			}, t1.footer)
		}) or nil
	})
end

return React.memo(SurveyModal)
