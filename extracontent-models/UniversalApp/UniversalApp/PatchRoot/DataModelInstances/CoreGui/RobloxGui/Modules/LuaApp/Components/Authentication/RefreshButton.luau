local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Roact = require(Modules.Common.Roact)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local ControlState = UIBlox.Core.Control.Enum.ControlState
local Interactable = UIBlox.Core.Control.Interactable
local v12 = Roact.PureComponent:extend("RefreshButton")

function v12.init(p1) -- line: 29
	-- upvalues: ControlState (copy)
	p1.state = {
		isRefreshing = false,
		isInCooldown = false,
		controlState = ControlState.Initialize
	}
	p1.loadSuggestions = p1.props.loadSuggestions
	p1.finishSuggestions = p1.props.finishSuggestions
	p1._isMounted = false
	p1.cooldownTimer = 0

	function p1.safeSetState(p2) -- line: 43
		-- upvalues: p1 (copy)
		if p1._isMounted then
			p1:setState(p2)
		end
	end
	function p1.onStateChanged(_, p4) -- line: 49
		-- upvalues: ControlState (copy), p1 (copy)
		if p4 == ControlState.Pressed then
			local onRefresh = p1.props.onRefresh
			local isRefreshing = p1.state.isRefreshing
			local isInCooldown = p1.state.isInCooldown

			if not isRefreshing and not isInCooldown and onRefresh then
				p1.loadSuggestions()
				p1.cooldownTimer = 0
				p1.safeSetState({
					isRefreshing = true,
					isInCooldown = true
				})
				onRefresh()
				p1.safeSetState({
					isRefreshing = false
				})
			end
		end

		if p4 == ControlState.Default then
			p1.safeSetState({
				isRefreshing = false
			})
		end
	end
	function p1.renderSteppedCallback(p5) -- line: 78
		-- upvalues: p1 (copy)
		if p1.state.isInCooldown then
			p1.cooldownTimer = p1.cooldownTimer + p5

			if p1.cooldownTimer >= 1.5 then
				p1.safeSetState({
					isInCooldown = false
				})
				p1.finishSuggestions()
			end
		end
	end
end
function v12.didMount(p6) -- line: 92
	p6._isMounted = true
end
function v12.willUnmount(p7) -- line: 96
	p7._isMounted = false
end
function v12.isDisabled(p8) -- line: 100
	local isRefreshing = p8.state.isRefreshing
	local isInCooldown = p8.state.isInCooldown

	return isRefreshing or isInCooldown
end

local function getCombinedTransparency(p9, p10) -- line: 108
	return 1 - (1 - p9) * (1 - p10)
end

function v12.render(p11) -- line: 112
	-- upvalues: withStyle (copy), Roact (copy), Interactable (copy), ImageSetLabel (copy), GetImageData (copy), ExternalEventConnection (copy), RunService (copy)
	local propsPosition = p11.props.Position
	local propsLayoutOrder = p11.props.LayoutOrder
	local v25 = p11:isDisabled()

	return withStyle(function(p12) -- line: 118
		-- upvalues: Roact (copy), Interactable (copy), propsPosition (copy), propsLayoutOrder (copy), p11 (copy), ImageSetLabel (copy), GetImageData (copy), v25 (copy), ExternalEventConnection (copy), RunService (copy)
		local createElement = Roact.createElement
		local v35 = Interactable
		local t1 = {
			Size = UDim2.new(0, 30, 0, 30),
			Position = propsPosition,
			BackgroundTransparency = 1,
			LayoutOrder = propsLayoutOrder,
			onStateChanged = p11.onStateChanged,
			[Roact.Event.Activated] = function() -- line: 125
			end
		}
		local t2 = {}
		local createElement2 = Roact.createElement
		local t3 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 30, 0, 30)
		}
		local t4 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}
		local createElement3 = Roact.createElement
		local v42 = ImageSetLabel
		local t5 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 25, 0, 25),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = GetImageData("LuaApp/icons/common_refresh") or "LuaApp/icons/common_refresh",
			ImageColor3 = p12.Theme.IconEmphasis.Color
		}
		local IconEmphasisTransparency = p12.Theme.IconEmphasis.Transparency
		local v45 = not v25 and 0 or 0.5

		t5.ImageTransparency = 1 - (1 - IconEmphasisTransparency) * (1 - v45)
		t4.Spinner = createElement3(v42, t5)
		t4.renderStepped = Roact.createElement(ExternalEventConnection, {
			event = RunService.renderStepped,
			callback = p11.renderSteppedCallback
		})
		t2.RefreshFrame = createElement2("Frame", t3, t4)

		return createElement(v35, t1, t2)
	end)
end

return v12
