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

local function GridItem(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), v15 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy), FFlagChromeActivatedMappedSignal (copy), useMappedSignal (copy), View (copy), IconHost (copy), FoundationText (copy)
	local v18 = React.useCallback(function() -- line: 34
		-- upvalues: t1 (copy), v15 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
		t1.onActivated()

		if not v15 then
			toggleSideSheet(false)
			SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
		end
	end, { t1.onActivated })
	local v19 = not not FFlagChromeActivatedMappedSignal and useMappedSignal(t1.isActivated)

	return React.createElement(View, {
		tag = "col align-x-center gap-xsmall size-1400 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		IconCircle = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["size-1400 radius-circle"] = true,
				["bg-shift-100"] = not v19,
				["bg-shift-400"] = v19
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
				onActivated = v18
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
