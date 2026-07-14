local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Chrome = require(InExperienceSideSheetParent.Chrome)
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local SharedFlags = require(InExperienceSideSheetParent.SharedFlags)
local FoundationText = Foundation.Text
local View = Foundation.View
local IconHost = require(script.Parent.IconHost)
local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)
local useMappedSignal = Chrome.Hooks.useMappedSignal
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local v15 = game:DefineFastFlag("KeepSideSheetOpenFromGrid", false)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local function GridItem(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), v15 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy), FFlagSideSheetFocusNav (copy), FFlagChromeActivatedMappedSignal (copy), useMappedSignal (copy), View (copy), IconHost (copy), FoundationText (copy)
	local v19 = React.useCallback(function() -- line: 39
		-- upvalues: t1 (copy), v15 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
		t1.onActivated()

		if not v15 then
			toggleSideSheet(false)
			SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
		end
	end, { t1.onActivated })
	local v20 = if not FFlagSideSheetFocusNav then nil else React.useRef(nil)
	local v21 = not not FFlagChromeActivatedMappedSignal and useMappedSignal(t1.isActivated)
	local v22 = if not FFlagSideSheetFocusNav then nil else React.useCallback(function(p1) -- line: 51
		-- upvalues: v20 (copy), t1 (copy)
		if v20 then
			v20.current = p1
		end

		if p1 and t1.firstIntegrationToFocusCallback then
			t1.firstIntegrationToFocusCallback(p1)
		end
	end, { t1.firstIntegrationToFocusCallback })

	return React.createElement(View, {
		tag = "col align-x-center gap-xsmall size-1400 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		IconCircle = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["size-1400 radius-circle"] = true,
				["bg-shift-100"] = not v21,
				["bg-shift-400"] = v21
			},
			selection = if not FFlagSideSheetFocusNav then nil else {
				Selectable = false
			}
		}, {
			IconHost = React.createElement(IconHost, {
				centerPosition = true,
				icon = t1.icon,
				notification = t1.notification
			}),
			ActivationOverlay = React.createElement(View, {
				tag = "size-full radius-circle",
				ZIndex = 10,
				onActivated = v19,
				selection = if not FFlagSideSheetFocusNav or not t1.disableGamepadDirections then nil else {
					Selectable = true,
					NextSelectionRight = if not t1.disableGamepadDirections or not t1.disableGamepadDirections.right then nil else v20
				},
				ref = if not FFlagSideSheetFocusNav then nil else v22
			})
		}),
		Label = React.createElement(FoundationText, {
			tag = "size-full-700 text-label-small text-wrap text-align-x-center text-align-y-top text-truncate-end content-default",
			LayoutOrder = 2,
			Text = t1.label
		})
	})
end

return React.memo(GridItem)
