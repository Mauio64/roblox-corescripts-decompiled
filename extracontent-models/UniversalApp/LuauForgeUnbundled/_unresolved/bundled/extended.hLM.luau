local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/bundled/egJ")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local controlState = UIBlox.Core.Control.Enum.ControlState
local interactable = UIBlox.Core.Control.Interactable

local extended = module.PureComponent:extend("RefreshButton")

function extended:init()
	self.state = {
		isRefreshing = false,
		isInCooldown = false,
		controlState = controlState.Initialize
	}

	self.loadSuggestions = self.props.loadSuggestions

	self.finishSuggestions = self.props.finishSuggestions

	self._isMounted = false
	self.cooldownTimer = 0

	function self.safeSetState(p2)
		if self._isMounted then
			self:setState(p2)
		end
	end

	function self.onStateChanged(p2, p3)
		if p3 == controlState.Pressed then
			local onRefresh = self.props.onRefresh
			local isRefreshing = self.state.isRefreshing
			local isInCooldown = self.state.isInCooldown

			if not (isRefreshing or isInCooldown) and onRefresh then
				self.loadSuggestions()
				self.cooldownTimer = 0
				self.safeSetState({ isRefreshing = true, isInCooldown = true })

				onRefresh()
				self.safeSetState({ isRefreshing = false })
			end
		end

		if p3 == controlState.Default then
			self.safeSetState({ isRefreshing = false })
		end
	end

	function self.renderSteppedCallback(p2)
		if self.state.isInCooldown then
			self.cooldownTimer += p2

			if self.cooldownTimer >= 1.5 then
				self.safeSetState({ isInCooldown = false })

				self.finishSuggestions()
			end
		end
	end
end

function extended:didMount()
	self._isMounted = true
end

function extended:willUnmount()
	self._isMounted = false
end

function extended.isDisabled(p2)
	local isRefreshing = p2.state.isRefreshing
	local isInCooldown = p2.state.isInCooldown

	return isRefreshing or isInCooldown
end

local function getCombinedTransparency(p2, p3)
	return 1 - (1 - p2) * (1 - p3)
end

function extended:render()
	local position = self.props.Position
	local layoutOrder = self.props.LayoutOrder

	local disabled = self:isDisabled()

	return withStyle(function(p2)
		return module.createElement(interactable, {
			Size = UDim2.new(0, 30, 0, 30),
			Position = position,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			onStateChanged = self.onStateChanged,
			[module.Event.Activated] = function() end
		}, {
			RefreshFrame = module.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(0, 30, 0, 30) },
				{
					UIListLayout = module.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					Spinner = module.createElement(imageSetLabel, {
						Size = UDim2.new(0, 25, 0, 25),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						BackgroundTransparency = 1,
						Image = getImageData("LuaApp/icons/common_refresh") or "LuaApp/icons/common_refresh",
						ImageColor3 = p2.Theme.IconEmphasis.Color,
						ImageTransparency = 1 - (1 - p2.Theme.IconEmphasis.Transparency) * (1 - (disabled and 0.5 or 0))
					}),
					renderStepped = module.createElement(module2, {
						event = RunService.renderStepped,
						callback = self.renderSteppedCallback
					})
				}
			)
		})
	end)
end

return extended
