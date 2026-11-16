local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent.Parent
local parent2 = parent.Parent

local HumanoidViewport = require(parent.HumanoidViewport)
local ItemsList = require(parent.ItemsList)

local SignalSaveAvatarPermissionDenied = require(parent2.Thunks.SignalSaveAvatarPermissionDenied)
local PerformSaveAvatar = require(parent2.Thunks.PerformSaveAvatar)

local GetConformedHumanoidDescription = require(parent2.GetConformedHumanoidDescription)

local extended = Roact.PureComponent:extend("SaveAvatarPrompt")

extended.validateProps = t.strictInterface({
	gameName = t.string,
	screenSize = t.Vector2,
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	performSaveAvatar = t.callback,
	signalSaveAvatarPermissionDenied = t.callback
})

function extended:init()
	self.mounted = false

	self:setState({
		conformedHumanoidDescription = nil,
		getConformedDescriptionFailed = false,
		itemListScrollable = false
	})

	self.middleContentRef = Roact.createRef()
	local binding, updateContentSize = Roact.createBinding(UDim2.new(1, 0, 0, 200))
	self.contentSize = binding
	self.updateContentSize = updateContentSize

	function self.onAlertSizeChanged(p)
		local absoluteSize = p.AbsoluteSize

		if not self.middleContentRef:getValue() then
			return
		end

		local y = self.middleContentRef:getValue().AbsoluteSize.Y
		local v = absoluteSize.Y - y
		local v2 = self.props.screenSize.Y - 60 - v

		local v3 = self.middleContentRef:getValue().AbsoluteSize.X / 2 - 10 + 80

		if v3 < v2 then
			v2 = v3
		end

		if y ~= v2 then
			self.updateContentSize(UDim2.new(1, 0, 0, v2))
		end
	end

	function self.itemListScrollableUpdated(itemListScrollable, p)
		if p == self.contentSize:getValue().Y.Offset then
			self:setState({ itemListScrollable = itemListScrollable })
		end
	end

	function self.retryLoadDescription()
		self:setState({ getConformedDescriptionFailed = false })

		self:getConformedHumanoidDescription()
	end

	function self.renderAlertMiddleContent()
		local conformedHumanoidDescription = self.state.conformedHumanoidDescription
		local getConformedDescriptionFailed = self.state.getConformedDescriptionFailed

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = self.contentSize,
				[Roact.Ref] = self.middleContentRef
			},
			{
				ItemsListFrame = Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.fromScale(0.45, 1) },
					{
						ItemsList = Roact.createElement(ItemsList, {
							humanoidDescription = conformedHumanoidDescription,
							retryLoadDescription = self.retryLoadDescription,
							loadingFailed = getConformedDescriptionFailed,
							itemListScrollableUpdated = self.itemListScrollableUpdated
						})
					}
				),
				HumanoidViewportFrame = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(0.55, 1),
						Position = UDim2.fromScale(0.45, 0),
						LayoutOrder = 2
					},
					{
						UIPadding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 5),
							PaddingRight = UDim.new(0, 5)
						}),
						HumanoidViewport = Roact.createElement(HumanoidViewport, {
							humanoidDescription = conformedHumanoidDescription,
							loadingFailed = getConformedDescriptionFailed,
							retryLoadDescription = self.retryLoadDescription,
							rigType = self.props.rigType
						})
					}
				),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = self.contentMaxSize
				})
			}
		)
	end
end

function extended.render(props)
	return Roact.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptText", {
			RBX_NAME = props.props.gameName
		}),
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = props.props.signalSaveAvatarPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptNo")
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.props.performSaveAvatar,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptYes")
					},
					isDefaultChild = false
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = props.props.screenSize,
		middleContent = props.renderAlertMiddleContent,
		onAbsoluteSizeChanged = props.onAlertSizeChanged,
		isMiddleContentFocusable = props.state.itemListScrollable
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
	if self.props.humanoidDescription ~= p.humanoidDescription then
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

local function mapStateToProps(data)
	return {
		gameName = data.gameName,
		screenSize = data.screenSize,
		humanoidDescription = data.promptInfo.humanoidDescription,
		rigType = data.promptInfo.rigType
	}
end

local function mapDispatchToProps(callback)
	return {
		signalSaveAvatarPermissionDenied = function()
			return callback(SignalSaveAvatarPermissionDenied)
		end,
		performSaveAvatar = function()
			return callback(PerformSaveAvatar)
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
