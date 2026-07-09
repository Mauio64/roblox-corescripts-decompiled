local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local GamesProductInfoReducer = require(CorePackages.Workspace.Packages.GameProductInfoRodux).GamesProductInfoReducer
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local GamePlayButton = require(CorePackages.Workspace.Packages.GamePlayButton)
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local useOnPlaySquadButtonCallback = GamePlayButton.useOnPlaySquadButtonCallback
local usePlayButtonState = GamePlayButton.usePlayButtonState
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local MenuDirection = require(CorePackages.Packages.UIBlox).App.Menu.MenuDirection
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PlayButton = require(Modules.LuaApp.Components.Games.PlayButton)
local FFlagLuaAppEnablePlaySquadButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnablePlaySquadButton
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local v18 = Roact.PureComponent:extend("PlayButtonContainer")

v18.validateProps = t.strictInterface({
	universeId = t.string,
	Size = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.number),
	referralSource = t.optional(t.string),
	experienceJoinData = t.optional(t.table),
	placeId = t.optional(t.string),
	testId = t.optional(t.string),
	onPlayButtonCallback = t.callback,
	onPlaySquadButtonCallback = if not FFlagLuaAppEnablePlaySquadButton then nil else t.callback,
	playButtonState = t.string,
	gameProductInfo = t.optional(t.table)
})

function v18.init(p1) -- line: 45
	-- upvalues: FFlagLuaAppEnablePlaySquadButton (copy)
	p1.isMounted = false

	function p1.onPlayButtonActivated() -- line: 48
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		p1.props.onPlayButtonCallback(p1.props.playButtonState)
	end

	p1.onPlaySquadButtonActivated = if not FFlagLuaAppEnablePlaySquadButton then nil else function(p2) -- line: 57
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		p1.props.onPlaySquadButtonCallback(p2)
	end
end
function v18.didMount(p3) -- line: 67
	p3.isMounted = true
end
function v18.willUnmount(p4) -- line: 71
	p4.isMounted = false
end
function v18.render(p5) -- line: 75
	-- upvalues: Roact (copy), PlayButton (copy), FFlagLuaAppEnablePlaySquadButton (copy)
	local propsSize = p5.props.Size
	local propsLayoutOrder = p5.props.LayoutOrder
	local playButtonState = p5.props.playButtonState
	local gameProductInfo = p5.props.gameProductInfo
	local v28 = gameProductInfo and gameProductInfo.price or 0

	return Roact.createElement(PlayButton, {
		Size = propsSize,
		LayoutOrder = propsLayoutOrder,
		playButtonState = playButtonState,
		price = v28,
		localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or "",
		onPlayButtonActivated = p5.onPlayButtonActivated,
		onPlaySquadButtonActivated = if not FFlagLuaAppEnablePlaySquadButton then nil else p5.onPlaySquadButtonActivated,
		testId = p5.props.testId
	})
end

local v19 = v18

return (RoactRodux.connect(function(p6, p7) -- line: 135
	-- upvalues: GamesProductInfoReducer (copy)
	local universeId = p7.universeId

	return {
		gameProductInfo = p6[GamesProductInfoReducer.key][universeId]
	}
end)(function(p8) -- line: 95
	-- upvalues: useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), useOnPlayButtonCallback (copy), FFlagLuaAppEnablePlaySquadButton (copy), useOnPlaySquadButtonCallback (copy), MenuDirection (copy), Cryo (copy), Roact (copy), v19 (copy)
	local v30 = useRoactService(RoactNetworking)
	local v31 = usePlayButtonState(v30, p8.universeId, nil, nil, not not FFlagLuaAppPlayButtonLoadingDurationTelemetry or nil, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else "PlayButton")
	local v32 = useOnPlayButtonCallback(p8.universeId, p8.referralSource, "PlayButton", nil, "LuaGameCard", p8.experienceJoinData, p8.placeId)
	local v33 = if not FFlagLuaAppEnablePlaySquadButton then nil else useOnPlaySquadButtonCallback(MenuDirection.Up, v31.playButtonState, p8.referralSource, p8.universeId)
	local v34 = Cryo.Dictionary.join(p8, {
		onPlayButtonCallback = v32,
		onPlaySquadButtonCallback = v33,
		playButtonState = v31.playButtonState
	})

	return Roact.createElement(v19, v34)
end))
