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
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local HumanoidViewport = require(ParentParent.HumanoidViewport)
local ItemsList = require(ParentParent.ItemsList)
local SignalSaveAvatarPermissionDenied = require(ParentParentParent.Thunks.SignalSaveAvatarPermissionDenied)
local PerformSaveAvatar = require(ParentParentParent.Thunks.PerformSaveAvatar)
local GetConformedHumanoidDescription = require(ParentParentParent.GetConformedHumanoidDescription)
local v17 = Roact.PureComponent:extend("SaveAvatarPrompt")

v17.validateProps = t.strictInterface({
	gameName = t.string,
	screenSize = t.Vector2,
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	performSaveAvatar = t.callback,
	signalSaveAvatarPermissionDenied = t.callback
})

function v17.init(p1) -- line: 47
	-- upvalues: Roact (copy), ItemsList (copy), HumanoidViewport (copy)
	p1.mounted = false
	p1:setState({
		conformedHumanoidDescription = nil,
		getConformedDescriptionFailed = false,
		itemListScrollable = false
	})
	p1.middleContentRef = Roact.createRef()

	local v21, v22 = Roact.createBinding(UDim2.new(1, 0, 0, 200))

	p1.contentSize = v21
	p1.updateContentSize = v22

	function p1.onAlertSizeChanged(p2) -- line: 59
		-- upvalues: p1 (copy)
		local AbsoluteSize = p2.AbsoluteSize

		if not p1.middleContentRef:getValue() then
			return
		end

		local AbsoluteSizeY = p1.middleContentRef:getValue().AbsoluteSize.Y
		local v36 = AbsoluteSize.Y - AbsoluteSizeY
		local v37 = p1.props.screenSize.Y - 60 - v36
		local v38 = p1.middleContentRef:getValue().AbsoluteSize.X / 2 - 10 + 80

		if v38 < v37 then
			v37 = v38
		end

		if AbsoluteSizeY ~= v37 then
			p1.updateContentSize(UDim2.new(1, 0, 0, v37))
		end
	end
	function p1.itemListScrollableUpdated(p3, p4) -- line: 82
		-- upvalues: p1 (copy)
		if p4 == p1.contentSize:getValue().Y.Offset then
			p1:setState({
				itemListScrollable = p3
			})
		end
	end
	function p1.retryLoadDescription() -- line: 90
		-- upvalues: p1 (copy)
		p1:setState({
			getConformedDescriptionFailed = false
		})
		p1:getConformedHumanoidDescription()
	end
	function p1.renderAlertMiddleContent() -- line: 98
		-- upvalues: p1 (copy), Roact (copy), ItemsList (copy), HumanoidViewport (copy)
		local conformedHumanoidDescription = p1.state.conformedHumanoidDescription
		local getConformedDescriptionFailed = p1.state.getConformedDescriptionFailed

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = p1.contentSize,
			[Roact.Ref] = p1.middleContentRef
		}, {
			ItemsListFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.45, 1)
			}, {
				ItemsList = Roact.createElement(ItemsList, {
					humanoidDescription = conformedHumanoidDescription,
					retryLoadDescription = p1.retryLoadDescription,
					loadingFailed = getConformedDescriptionFailed,
					itemListScrollableUpdated = p1.itemListScrollableUpdated
				})
			}),
			HumanoidViewportFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromScale(0.55, 1),
				Position = UDim2.fromScale(0.45, 0)
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 5),
					PaddingRight = UDim.new(0, 5)
				}),
				HumanoidViewport = Roact.createElement(HumanoidViewport, {
					humanoidDescription = conformedHumanoidDescription,
					loadingFailed = getConformedDescriptionFailed,
					retryLoadDescription = p1.retryLoadDescription,
					rigType = p1.props.rigType
				})
			}),
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = p1.contentMaxSize
			})
		})
	end
end
function v17.render(p5) -- line: 146
	-- upvalues: Roact (copy), InteractiveAlert (copy), RobloxTranslator (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptText", {
			RBX_NAME = p5.props.gameName
		}),
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p5.props.signalSaveAvatarPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptNo")
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p5.props.performSaveAvatar,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.SaveAvatarPromptYes")
					}
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = p5.props.screenSize,
		middleContent = p5.renderAlertMiddleContent,
		onAbsoluteSizeChanged = p5.onAlertSizeChanged,
		isMiddleContentFocusable = p5.state.itemListScrollable
	})
end
function v17.getConformedHumanoidDescription(p6, p7) -- line: 179
	-- upvalues: GetConformedHumanoidDescription (copy)
	GetConformedHumanoidDescription(p7, true):andThen(function(p8) -- line: 181
		-- upvalues: p6 (copy)
		if not p6.mounted then
			return
		end

		p6:setState({
			conformedHumanoidDescription = p8
		})
	end, function(_) -- line: 189
		-- upvalues: p6 (copy)
		if not p6.mounted then
			return
		end

		p6:setState({
			getConformedDescriptionFailed = true
		})
	end)
end
function v17.didMount(p10) -- line: 200
	p10.mounted = true
	p10:getConformedHumanoidDescription(p10.props.humanoidDescription)
end
function v17.didUpdate(p11, p12, _) -- line: 206
	-- upvalues: Roact (copy)
	if p11.props.humanoidDescription ~= p12.humanoidDescription then
		p11:setState({
			getConformedDescriptionFailed = false,
			conformedHumanoidDescription = Roact.None
		})
		p11:getConformedHumanoidDescription(p11.props.humanoidDescription)
	end
end
function v17.willUnmount(p14) -- line: 217
	p14.mounted = false
end

local function mapStateToProps(p15) -- line: 221
	return {
		gameName = p15.gameName,
		screenSize = p15.screenSize,
		humanoidDescription = p15.promptInfo.humanoidDescription,
		rigType = p15.promptInfo.rigType
	}
end
local function mapDispatchToProps(p16) -- line: 230
	-- upvalues: SignalSaveAvatarPermissionDenied (copy), PerformSaveAvatar (copy)
	return {
		signalSaveAvatarPermissionDenied = function() -- line: 232
			-- upvalues: p16 (copy), SignalSaveAvatarPermissionDenied (copy)
			return p16(SignalSaveAvatarPermissionDenied)
		end,
		performSaveAvatar = function() -- line: 236
			-- upvalues: p16 (copy), PerformSaveAvatar (copy)
			return p16(PerformSaveAvatar)
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v17)
