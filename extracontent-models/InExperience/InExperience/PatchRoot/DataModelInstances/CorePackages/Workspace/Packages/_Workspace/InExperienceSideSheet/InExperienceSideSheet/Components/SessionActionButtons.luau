local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableWhatsNew = SharedFlags.FFlagEnableWhatsNew
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local whatsNewAnchor

if FFlagEnableWhatsNew then
	local WhatsNew = require(parent.WhatsNew)
	whatsNewAnchor = WhatsNew.WhatsNewAnchor
else
	whatsNewAnchor = nil
end

local GetSessionActionButtonsStore = require(InExperienceSideSheet.Stores.GetSessionActionButtonsStore)

local buildSessionActionButtonLayout = require(InExperienceSideSheet.Utils.buildSessionActionButtonLayout)

local function getSessionActionButtonConfigs(p)
	return GetSessionActionButtonsStore(p).sessionActionButtonConfigs
end

local function SessionActionButtons(p)
	local v = SignalsReact.useSignalState(getSessionActionButtonConfigs)
	local v2

	if FFlagShowSwitchServerButton or isPioneerLaunch() then
		v2 = {}

		for _, v3 in v do
			if v3.getIsHidden == nil or not v3.getIsHidden() then
				table.insert(v2, v3)
			end
		end
	else
		v2 = v
	end

	local sessionActionButtonLayout = buildSessionActionButtonLayout(v2)

	local element = React.createElement(
		View,
		{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = p.layoutOrder },
		sessionActionButtonLayout
	)

	if FFlagEnableWhatsNew then
		return React.createElement(whatsNewAnchor, {
			anchorId = "LeaveRespawn",
			LayoutOrder = p.layoutOrder
		}, {
			SessionActions = element
		})
	end

	return element
end

return React.memo(SessionActionButtons)
