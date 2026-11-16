local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local parent = script.Parent.Parent
local parent2 = parent.Parent

local HumanoidViewport = require(parent.HumanoidViewport)

local GetConformedHumanoidDescription = require(parent2.GetConformedHumanoidDescription)

local extended = Roact.PureComponent:extend("PromptWithAvatarViewport")

extended.validateProps = t.strictInterface({
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	title = t.string,
	bodyText = t.optional(t.string),
	buttonStackInfo = t.table,
	screenSize = t.Vector2
})

function extended:init()
	self.mounted = false

	self.middleContentRef = Roact.createRef()
	local binding, updateContentSize = Roact.createBinding(UDim2.new(1, 0, 0, 200))
	self.contentSize = binding
	self.updateContentSize = updateContentSize

	self:setState({ conformedHumanoidDescription = nil, getConformedDescriptionFailed = false })

	function self.onAlertSizeChanged(p)
		local absoluteSize = p.AbsoluteSize

		if not self.middleContentRef:getValue() then
			return
		end

		local y = self.middleContentRef:getValue().AbsoluteSize.Y
		local v = absoluteSize.Y - y
		local v2 = self.props.screenSize.Y - 60 - v

		local v3 = self.middleContentRef:getValue().AbsoluteSize.X - 20

		if v3 < v2 then
			v2 = v3
		end

		if y ~= v2 then
			self.updateContentSize(UDim2.new(1, 0, 0, v2))
		end
	end

	function self.retryLoadDescription()
		self:setState({ getConformedDescriptionFailed = false })

		self:getConformedHumanoidDescription()
	end
end

function extended:renderAlertMiddleContent()
	local conformedHumanoidDescription = self.state.conformedHumanoidDescription
	local getConformedDescriptionFailed = self.state.getConformedDescriptionFailed

	return Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = self.contentSize, [Roact.Ref] = self.middleContentRef },
		{
			HumanoidViewport = Roact.createElement(HumanoidViewport, {
				humanoidDescription = conformedHumanoidDescription,
				loadingFailed = getConformedDescriptionFailed,
				retryLoadDescription = self.retryLoadDescription,
				rigType = self.props.rigType
			})
		}
	)
end

function extended:render()
	return Roact.createElement(InteractiveAlert, {
		title = self.props.title,
		bodyText = self.props.bodyText,
		buttonStackInfo = self.props.buttonStackInfo,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = self.props.screenSize,
		middleContent = function()
			return self:renderAlertMiddleContent()
		end,
		onAbsoluteSizeChanged = self.onAlertSizeChanged,
		isMiddleContentFocusable = false
	})
end

function extended:getConformedHumanoidDescription(p)
	GetConformedHumanoidDescription(p, true):andThen(function(conformedHumanoidDescription)
		if not self.mounted then
			return
		end

		self:setState({ conformedHumanoidDescription = conformedHumanoidDescription })
	end, function(_)
		if not self.mounted then
			return
		end

		self:setState({ getConformedDescriptionFailed = true })
	end)
end

function extended:didMount()
	self.mounted = true

	self:getConformedHumanoidDescription(self.props.humanoidDescription)
end

function extended:didUpdate(p, _)
	if p.humanoidDescription ~= self.props.humanoidDescription then
		self:setState({
			conformedHumanoidDescription = Roact.None,
			getConformedDescriptionFailed = false
		})

		self:getConformedHumanoidDescription(self.props.humanoidDescription)
	end
end

function extended:willUnmount()
	self.mounted = false
end

local function mapStateToProps(p)
	return { screenSize = p.screenSize }
end

return (RoactRodux.connect(mapStateToProps, nil)(extended))
