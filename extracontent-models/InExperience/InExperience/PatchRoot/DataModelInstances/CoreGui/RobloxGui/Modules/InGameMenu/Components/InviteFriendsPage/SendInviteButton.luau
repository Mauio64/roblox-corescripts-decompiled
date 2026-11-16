local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Resources.Constants)
local InviteStatus = Constants.InviteStatus

local Images = UIBlox.App.ImageSet.Images

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local IconSize = Foundation.Enums.IconSize

local extended = Roact.PureComponent:extend("SendInviteButton")

extended.validateProps = t.strictInterface({
	onActivated = t.callback,
	animationBegun = t.callback,
	animationEnded = t.callback,
	userInviteStatus = t.optional(t.string)
})

local function linearTween(p, p2, p3)
	local v3 = (p3 - p2) / 30
	return (p - p2 / 30) / v3
end

local function isBetweenFrames(p, p2, p3): boolean
	return p2 / 30 <= p and p <= p3 / 30
end

local v3 = {
	[InviteStatus.Pending] = function(p, p2)
		local v3 = math.sin(6.283185307179586 * p) * 0.375 + 0.375
		p2.sendTransparency(v3)
	end,
	[InviteStatus.Success] = function(p, data, callback)
		local v3

		if p >= 0 then
			v3 = p <= 2 / 15
		else
			v3 = false
		end

		if v3 then
			local v4 = (p - 0) / (2 / 15)

			data.sendTransparency(v4)
			data.successTransparency(1 - v4)

			local v5 = 0.75 + 0.75 * (1 - v4)
			data.successSize(v5)
		else
			local v4

			if p >= 2 / 15 then
				v4 = p <= 0.3
			else
				v4 = false
			end

			if v4 then
				data.sendTransparency(1)
				data.successTransparency(0)
				local v5 = 0.75 + 0.25 * ((p - 2 / 15) / (1 / 6))
				data.successSize(v5)
			else
				data.successSize(1)
				callback()
			end
		end
	end,
	[InviteStatus.Failed] = function(p, data, callback)
		local v3

		if p >= 0 then
			v3 = p <= 1 / 15
		else
			v3 = false
		end

		if v3 then
			local v4 = (p - 0) / (2 / 15)

			data.sendTransparency(v4)
		else
			local v4

			if p >= 1 / 15 then
				v4 = p <= 26 / 15
			else
				v4 = false
			end

			if v4 then
				data.sendTransparency(1)
			else
				local v5

				if p >= 26 / 15 then
					v5 = p <= 1.9
				else
					v5 = false
				end

				if v5 then
					local v6 = (p - 26 / 15) / (1 / 6)

					data.sendTransparency(1 - v6)
				else
					data.sendTransparency(0)
					callback()
				end
			end
		end

		local v4

		if p >= 0 then
			v4 = p <= 2 / 15
		else
			v4 = false
		end

		if v4 then
			local v5 = (p - 0) / (2 / 15)

			data.failTransparency(1 - v5)
		else
			local v5

			if p >= 2 / 15 then
				v5 = p <= 1.4
			else
				v5 = false
			end

			if v5 then
				data.failTransparency(0)

				local v6 = p - 2 / 15
				local v7 = -0.4 * 2.71828182846 ^ (-v6 * 8) * math.sin(v6 * 40)
				data.failPos(v7)
			else
				local v6

				if p >= 1.4 then
					v6 = p <= 47 / 30
				else
					v6 = false
				end

				if not v6 then
					data.failTransparency(1)

					return
				end

				data.failPos(0)
				local v7 = (p - 1.4) / (1 / 6)

				data.failTransparency(v7)
			end
		end
	end
}

function extended:init(p)
	local binding, sendTransparency = Roact.createBinding(0)
	local binding2, successTransparency = Roact.createBinding(1)
	local binding3, failTransparency = Roact.createBinding(1)

	local binding4, successSize = Roact.createBinding(1)
	local binding5, failPos = Roact.createBinding(0)

	self.bindings = {
		sendTransparency = binding,
		successTransparency = binding2,
		failTransparency = binding3,
		successSize = binding4:map(function(p2)
			return UDim2.new(p2, 0, p2, 0)
		end),
		successScale = binding4,
		failPos = binding5:map(function(p2)
			return UDim2.new(p2, 0, 0, 0)
		end)
	}

	self.updateBindings = {
		sendTransparency = sendTransparency,
		successTransparency = successTransparency,
		failTransparency = failTransparency,
		successSize = successSize,
		failPos = failPos
	}

	if p.userInviteStatus == InviteStatus.Success then
		successTransparency(0)
		sendTransparency(1)
	end
end

function extended:renderWithSelectionCursor(callback)
	local props = self.props

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				IconEmphasis = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				}
			},
			IconSize = p.Size.Size_800
		}
	end, function(p)
		local createElement = Roact.createElement
		local v4 = {
			Selectable = false,
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			SelectionImageObject = callback(v2.InputFields),
			[Roact.Event.Activated] = function()
				local v4 = props.userInviteStatus == InviteStatus.Pending
				local v5 = props.userInviteStatus == InviteStatus.Success

				if not (self.renderSteppedConnection or v4 or v5) then
					props.onActivated()
				end
			end
		}
		local sendLabel

		if FFlagCoreUiMigrateUIBloxToFoundation then
			sendLabel = Roact.createElement(Icon, {
				name = IconName.PersonArrowFromBottomRight,
				variant = IconVariant.Regular,
				size = IconSize.XXLarge,
				style = self.bindings.sendTransparency:map(function(transparency)
					return { Color3 = p.Theme.IconEmphasis.Color, Transparency = transparency }
				end)
			})
		else
			sendLabel = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/actions/friends/friendInvite"],
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p.Theme.IconEmphasis.Color,
				ImageTransparency = self.bindings.sendTransparency
			})
		end

		local successLabel

		if FFlagCoreUiMigrateUIBloxToFoundation then
			successLabel = Roact.createElement(Icon, {
				name = IconName.CheckLarge,
				variant = IconVariant.Filled,
				size = self.bindings.successScale:map(function(p2)
					return p.IconSize * p2
				end),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				style = self.bindings.successTransparency:map(function(transparency)
					return { Color3 = p.Theme.IconEmphasis.Color, Transparency = transparency }
				end)
			})
		else
			successLabel = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/status/success"],
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = p.Theme.IconEmphasis.Color,
				ImageTransparency = self.bindings.successTransparency,
				Size = self.bindings.successSize
			})
		end

		local failLabel

		if FFlagCoreUiMigrateUIBloxToFoundation then
			failLabel = Roact.createElement(Icon, {
				name = IconName.TriangleExclamation,
				variant = IconVariant.Filled,
				size = IconSize.XXLarge,
				style = self.bindings.failTransparency:map(function(transparency)
					return { Color3 = p.Theme.IconEmphasis.Color, Transparency = transparency }
				end),
				Position = self.bindings.failPos
			})
		else
			failLabel = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/status/alert"],
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p.Theme.IconEmphasis.Color,
				ImageTransparency = self.bindings.failTransparency,
				Position = self.bindings.failPos
			})
		end

		return createElement("TextButton", v4, {
			SendLabel = sendLabel,
			SuccessLabel = successLabel,
			FailLabel = failLabel
		})
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended:didUpdate(p)
	if self.props.userInviteStatus and self.props.userInviteStatus ~= p.userInviteStatus then
		self:playAnimation(v3[self.props.userInviteStatus])
	end
end

function extended:didMount()
	if self.props.userInviteStatus then
		self:playAnimation(v3[self.props.userInviteStatus])
	end
end

function extended:playAnimation(animationFunction)
	self.animationStartTime = tick()
	self.animationFunction = animationFunction

	if not self.renderSteppedConnection then
		self.renderSteppedConnection = RunService.RenderStepped:Connect(function()
			self.animationFunction(tick() - self.animationStartTime, self.updateBindings, function()
				self:stopAnimation()
			end)
		end)
		self.props.animationBegun()
	end
end

function extended:stopAnimation()
	if self.renderSteppedConnection then
		self.renderSteppedConnection:Disconnect()
		self.renderSteppedConnection = nil
		self.props.animationEnded()
	end
end

function extended:willUnmount()
	self:stopAnimation()
end

return extended
