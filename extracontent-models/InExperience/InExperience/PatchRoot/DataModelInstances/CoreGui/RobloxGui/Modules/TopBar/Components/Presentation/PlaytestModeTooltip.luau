local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useIsPlaytestMode = require(RobloxGui.Modules.Chrome.ChromeShared.Hooks.useIsPlaytestMode)
local EducationalTooltip = Foundation.EducationalTooltip
local OverlayProvider = Foundation.OverlayProvider
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local ButtonVariant = Foundation.Enums.ButtonVariant
local v13 = game:DefineFastString("PlaytestModeTooltipLearnMoreUrl", "https://about.roblox.com/community-standards")
local v14 = game:DefineFastInt("PlaytestModeTooltipDisplayOrder", -1)
local u15 = false

local function getCanShow(p1) -- line: 30
	-- upvalues: u15 (ref)
	return not u15 and (p1 ~= nil and p1.current ~= nil)
end
local function PlaytestModeTooltip(t1: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy), useIsPlaytestMode (copy), React (copy), u15 (ref), LinkingProtocol (copy), v13 (copy), OverlayProvider (copy), v14 (copy), EducationalTooltip (copy), PopoverSide (copy), PopoverAlign (copy), ButtonVariant (copy)
	local v20 = useLocalization({
		title = "CoreScripts.FTUX.Heading.ReadyToPlaytest",
		text = "CoreScripts.FTUX.Description.WhiteMenuPlaytestMode",
		continueText = "CommonUI.Features.Action.Continue",
		learnMoreText = "CommonUI.Features.Action.LearnMore"
	})
	local v21 = useIsPlaytestMode()
	local useState = React.useState
	local anchorRef = t1.anchorRef
	local v24, v25 = useState(not u15 and (anchorRef ~= nil and anchorRef.current ~= nil))

	React.useEffect(function() -- line: 46
		-- upvalues: v25 (copy), t1 (copy), u15 (ref)
		local v28 = v25
		local anchorRef2 = t1.anchorRef

		v28(not u15 and (anchorRef2 ~= nil and anchorRef2.current ~= nil))
	end, { t1.anchorRef })

	local v26 = React.useCallback(function() -- line: 50
		-- upvalues: u15 (ref), v25 (copy)
		u15 = true
		v25(false)
	end, {})
	local v27 = React.useCallback(function() -- line: 55
		-- upvalues: LinkingProtocol (copy), v13 (copy), u15 (ref), v25 (copy)
		LinkingProtocol.default:openURL(v13)
		u15 = true
		v25(false)
	end, {})

	if u15 or (not v21 or not v24) then
		return nil
	end

	return React.createElement(OverlayProvider, {
		DisplayOrder = v14
	}, {
		Tooltip = React.createElement(EducationalTooltip, {
			isOpen = true,
			anchorRef = t1.anchorRef,
			title = v20.title,
			text = v20.text,
			side = PopoverSide.Bottom,
			align = PopoverAlign.Start,
			onClose = v26,
			actions = {
				{
					text = v20.continueText,
					variant = ButtonVariant.Emphasis,
					onActivated = v26
				},
				{
					text = v20.learnMoreText,
					variant = ButtonVariant.Standard,
					onActivated = v27
				}
			}
		})
	})
end

return React.memo(PlaytestModeTooltip)
