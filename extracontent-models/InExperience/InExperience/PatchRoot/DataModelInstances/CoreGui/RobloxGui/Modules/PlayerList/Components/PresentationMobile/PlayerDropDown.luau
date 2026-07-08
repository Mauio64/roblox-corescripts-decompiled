local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local useLayoutValues = PlayerList.Common.useLayoutValues
local ParentParent = script.Parent.Parent
local Connection = ParentParent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local DropDownButton = require(script.Parent.DropDownButton)
local DropDownPlayerHeader = require(script.Parent.DropDownPlayerHeader)
local FriendDropDownButton = require(script.Parent.FriendDropDownButton)
local LocalPlayer = Players.LocalPlayer
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local onBlockButtonActivated = require(RobloxGui.Modules.Settings.onBlockButtonActivated)
local Images = UIBlox.App.ImageSet.Images
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local ParentParentParent = ParentParent.Parent
local ClosePlayerDropDown = require(ParentParentParent.Actions.ClosePlayerDropDown)
local SetPlayerListVisibility = require(ParentParentParent.Actions.SetPlayerListVisibility)
local FFlagPlayerListReduceRerenders = require(ParentParentParent.Flags.FFlagPlayerListReduceRerenders)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local UnblockPlayer = require(ParentParentParent.Thunks.UnblockPlayer)
local RequestFriendship = require(ParentParentParent.Thunks.RequestFriendship)
local SetPlayerIsBlocked = require(ParentParentParent.Actions.SetPlayerIsBlocked)
local v35 = Roact.PureComponent:extend("PlayerDropDown")
local FFlagStandardizeSafetyIcon = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStandardizeSafetyIcon
local FFlagAllowDisplayingFoundationIconsForDropdown = require(ParentParentParent.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

v35.validateProps = t.strictInterface({
	contentsVisible = t.boolean,
	selectedPlayer = t.optional(t.instanceIsA("Player")),
	isVisible = t.boolean,
	playerRelationship = t.optional(t.strictInterface({
		isBlocked = t.boolean,
		friendStatus = t.enum(Enum.FriendStatus),
		isFollowing = t.boolean,
		isFollower = t.boolean
	})),
	inspectMenuEnabled = t.boolean,
	isTenFootInterface = t.boolean,
	isUsingGamepad = t.optional(t.boolean),
	subjectToChinaPolicies = t.boolean,
	preferredTransparency = t.number,
	closeDropDown = t.callback,
	blockPlayerSuccess = t.callback,
	unblockPlayer = t.callback,
	requestFriendship = t.callback,
	setPlayerListVisibility = t.callback,
	focusGuiObject = t.optional(t.callback),
	focusedGuiObject = t.optional(t.instanceIsA("GuiObject")),
	layoutValues = t.optional(t.table)
})

local t1 = {
	dampingRatio = 1,
	frequency = 4
}

function v35.init(p1) -- line: 90
	-- upvalues: React (copy), Roact (copy), Otter (copy)
	p1.state = {
		allVisible = false,
		contentVisible = false
	}
	p1.buttonsContainerRef = React.createRef()

	local v43, v44 = Roact.createBinding(1)

	p1.containerScale = v43
	p1.updateContainerScale = v44
	p1.containerScaleMotor = Otter.createSingleMotor(0)
	p1.containerScaleMotor:onStep(function(p2) -- line: 100
		-- upvalues: p1 (copy)
		p1.updateContainerScale(p2)
	end)

	local v45, v46 = Roact.createBinding(1)

	p1.transparency = v45
	p1.updateTransparency = v46
	p1.transparencyMotor = Otter.createSingleMotor(0)
	p1.transparencyMotor:onStep(function(p3) -- line: 106
		-- upvalues: p1 (copy)
		p1.updateTransparency(p3)

		if p3 < 0.5 and (p1.props.isVisible and p1.props.contentsVisible) then
			p1:setState({
				contentVisible = true
			})
		else
			p1:setState({
				contentVisible = false
			})
		end

		p1:setState({
			allVisible = p3 < 1
		})
	end)

	local v47, v48 = Roact.createBinding(1)

	p1.buttonTransparency = v47
	p1.updateButtonTransparency = v48
	p1.buttonTransparencyMotor = Otter.createSingleMotor(0)
	p1.buttonTransparencyMotor:onStep(function(p4) -- line: 124
		-- upvalues: p1 (copy)
		p1.updateButtonTransparency(p4)
	end)
end
function v35.createFriendButton(p5, p6) -- line: 129
	-- upvalues: Roact (copy), FriendDropDownButton (copy)
	local selectedPlayer = p5.props.selectedPlayer

	return Roact.createElement(FriendDropDownButton, {
		layoutOrder = 1,
		playerRelationship = p6,
		selectedPlayer = selectedPlayer,
		dropDownOpen = p5.props.isVisible,
		requestFriendship = p5.props.requestFriendship,
		contentVisible = p5.state.contentVisible,
		isUsingGamepad = p5.props.isUsingGamepad
	})
end
function v35.createBlockButton(p7, p8) -- line: 142
	-- upvalues: RobloxTranslator (copy), Images (copy), Roact (copy), DropDownButton (copy), onBlockButtonActivated (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
	local selectedPlayer = p7.props.selectedPlayer
	local v55 = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Block")
	local v56 = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.UnBlock")
	local v57 = Images["icons/actions/block"]

	return Roact.createElement(DropDownButton, {
		layoutOrder = 4,
		lastButton = false,
		forceShowOptions = false,
		contentVisible = p7.state.contentVisible,
		buttonTransparency = p7.buttonTransparency,
		text = p8.isBlocked and v56 or v55,
		icon = v57,
		onActivated = function() -- line: 156
			-- upvalues: p8 (copy), p7 (copy), selectedPlayer (copy), onBlockButtonActivated (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
			if p8.isBlocked then
				p7.props.unblockPlayer(selectedPlayer)

				return
			end

			onBlockButtonActivated(selectedPlayer, nil, p7.__componentName, {
				onBlockingSuccess = function() -- line: 161
					-- upvalues: p7 (copy), selectedPlayer (copy)
					p7.props.blockPlayerSuccess(selectedPlayer)
				end,
				onBlockingModalClose = if not FFlagAddNewPlayerListMobileFocusNav then nil else function() -- line: 165
					-- upvalues: p7 (copy)
					if p7.props.isUsingGamepad then
						p7.props.focusGuiObject(p7.buttonsContainerRef.current)
					end
				end
			})
		end
	})
end
function v35.createReportButton(p9) -- line: 177
	-- upvalues: FFlagStandardizeSafetyIcon (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), Images (copy), Roact (copy), DropDownButton (copy), RobloxTranslator (copy), isNewInGameMenuEnabled (copy), RobloxGui (copy)
	local selectedPlayer = p9.props.selectedPlayer
	local v60 = if not FFlagStandardizeSafetyIcon or not FFlagAllowDisplayingFoundationIconsForDropdown then Images["icons/actions/feedback"] else "Flag"

	return Roact.createElement(DropDownButton, {
		layoutOrder = 5,
		lastButton = true,
		forceShowOptions = false,
		contentVisible = p9.state.contentVisible,
		buttonTransparency = p9.buttonTransparency,
		text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Report"),
		icon = v60,
		onActivated = function() -- line: 192
			-- upvalues: isNewInGameMenuEnabled (copy), RobloxGui (copy), selectedPlayer (copy), p9 (copy)
			if isNewInGameMenuEnabled() then
				require(RobloxGui.Modules.InGameMenuInit).openReportDialog(selectedPlayer, p9.__componentName)

				return
			end

			require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuNewContainerPage):ReportPlayer(selectedPlayer, p9.__componentName)
			p9.props.closeDropDown()
		end
	})
end
function v35.createInspectButton(p10) -- line: 206
	-- upvalues: Images (copy), Roact (copy), DropDownButton (copy), RobloxTranslator (copy), LocalPlayer (copy), GuiService (copy)
	local selectedPlayer = p10.props.selectedPlayer
	local v63 = Images["icons/actions/zoomIn"]

	return Roact.createElement(DropDownButton, {
		layoutOrder = 3,
		forceShowOptions = false,
		contentVisible = p10.state.contentVisible,
		buttonTransparency = p10.buttonTransparency,
		text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Examine"),
		icon = v63,
		lastButton = selectedPlayer == LocalPlayer,
		onActivated = function() -- line: 218
			-- upvalues: GuiService (copy), selectedPlayer (copy), p10 (copy)
			GuiService:InspectPlayerFromUserIdWithCtx(selectedPlayer.UserId, "leaderBoard")
			p10.props.closeDropDown()
			p10.props.setPlayerListVisibility(false)
		end
	})
end
function v35.render(p11) -- line: 226
	-- upvalues: WithLayoutValues (copy), Roact (copy), DropDownPlayerHeader (copy), LocalPlayer (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
	return WithLayoutValues(function(_) -- line: 227
		-- upvalues: p11 (copy), Roact (copy), DropDownPlayerHeader (copy), LocalPlayer (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
		local layoutValues = p11.props.layoutValues
		local selectedPlayer = p11.props.selectedPlayer

		if not selectedPlayer or p11.props.isTenFootInterface then
			return nil
		end

		local t2 = {
			UIScale = Roact.createElement("UIScale", {
				Scale = p11.containerScale
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, layoutValues.DropDownButtonPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			PlayerHeader = Roact.createElement(DropDownPlayerHeader, {
				player = p11.props.selectedPlayer,
				contentVisible = p11.state.contentVisible,
				transparency = p11.transparency
			})
		}
		local v88 = 4 * layoutValues.DropDownButtonSizeY + layoutValues.DropDownHeaderSizeY
		local v89 = layoutValues.DropDownButtonPadding + layoutValues.DropDownHeaderSizeY
		local playerRelationship = p11.props.playerRelationship

		if selectedPlayer ~= LocalPlayer then
			if not playerRelationship.isBlocked then
				t2.FriendButton = p11:createFriendButton(playerRelationship)
				v89 = v89 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY
			end

			t2.BlockButton = p11:createBlockButton(playerRelationship)

			local v91 = v89 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY

			t2.ReportButton = p11:createReportButton()
			v89 = v91 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY
		end

		if p11.props.inspectMenuEnabled then
			t2.InspectButton = p11:createInspectButton()
			v89 = v89 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY
		end

		local v92 = v89 - layoutValues.DropDownButtonPadding

		return Roact.createElement("ImageButton", {
			LayoutOrder = p11.props.layoutOrder,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Selectable = false,
			Modal = false,
			Visible = p11.state.allVisible,
			AutoButtonColor = false,
			Active = p11.props.isVisible,
			Image = "",
			SelectionGroup = not not FFlagAddNewPlayerListMobileFocusNav or nil,
			SelectionBehaviorUp = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			[Roact.Event.Activated] = p11.props.closeDropDown,
			[Roact.Ref] = p11.imageButtonRef
		}, {
			Container = Roact.createElement("Frame", {
				LayoutOrder = p11.props.layoutOrder,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.5, -v88 / 2),
				Size = UDim2.new(0, layoutValues.PlayerDropDownSizeXMobile, 0, v92),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Roact.Ref] = if not FFlagAddNewPlayerListMobileFocusNav then nil else p11.buttonsContainerRef
			}, t2)
		})
	end)
end
function v35.getScale(p13) -- line: 310
	if p13.props.isVisible and p13.props.contentsVisible then
		return 1
	end

	return 1.25
end
function v35.getTransparency(p14) -- line: 317
	if p14.props.isVisible and p14.props.contentsVisible then
		return 0
	end

	return 1
end
function v35.getButtonTransparency(p15) -- line: 324
	if p15.props.isVisible and p15.props.contentsVisible then
		return p15.props.preferredTransparency * 0.3
	end

	return 1
end
function v35.didUpdate(p16, _, p18) -- line: 331
	-- upvalues: Otter (copy), t1 (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
	p16.containerScaleMotor:setGoal(Otter.spring(p16:getScale(), t1))
	p16.transparencyMotor:setGoal(Otter.spring(p16:getTransparency(), t1))
	p16.buttonTransparencyMotor:setGoal(Otter.spring(p16:getButtonTransparency(), t1))

	if FFlagAddNewPlayerListMobileFocusNav and p16.props.isUsingGamepad and ((p18.contentVisible ~= p16.state.contentVisible or not p16.props.focusedGuiObject) and p16.state.contentVisible and p16.buttonsContainerRef.current) then
		p16.props.focusGuiObject(p16.buttonsContainerRef.current)

		if not FFlagAddNewPlayerListMobileFocusNav then
			p16.buttonsContainerRef.current.SelectionGroup = true
			p16.buttonsContainerRef.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			p16.buttonsContainerRef.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			p16.buttonsContainerRef.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			p16.buttonsContainerRef.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		end
	end
end
function v35.didMount(_) -- line: 352
end
function v35.willUnmount(p20) -- line: 354
	p20.transparencyMotor:destroy()
	p20.containerScaleMotor:destroy()
	p20.buttonTransparencyMotor:destroy()
	p20.transparencyMotor = nil
	p20.containerScaleMotor = nil
	p20.buttonTransparencyMotor = nil
end

local function mapStateToProps(p21) -- line: 364
	-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy)
	local selectedPlayer = p21.playerDropDown.selectedPlayer
	local v75 = p21.playerDropDown.isVisible and p21.displayOptions.isVisible

	return {
		selectedPlayer = selectedPlayer,
		isVisible = v75,
		playerRelationship = selectedPlayer and p21.playerRelationship[selectedPlayer.UserId],
		inspectMenuEnabled = p21.displayOptions.inspectMenuEnabled,
		isTenFootInterface = p21.displayOptions.isTenFootInterface,
		isUsingGamepad = if not FFlagAddNewPlayerListMobileFocusNav then nil else p21.displayOptions.isUsingGamepad,
		subjectToChinaPolicies = p21.displayOptions.subjectToChinaPolicies,
		preferredTransparency = p21.settings.preferredTransparency
	}
end
local function mapDispatchToProps(p22) -- line: 381
	-- upvalues: ClosePlayerDropDown (copy), SetPlayerListVisibility (copy), SetPlayerIsBlocked (copy), UnblockPlayer (copy), RequestFriendship (copy)
	return {
		closeDropDown = function() -- line: 383
			-- upvalues: p22 (copy), ClosePlayerDropDown (copy)
			return p22(ClosePlayerDropDown())
		end,
		setPlayerListVisibility = function(p23) -- line: 387
			-- upvalues: p22 (copy), SetPlayerListVisibility (copy)
			return p22(SetPlayerListVisibility(p23))
		end,
		blockPlayerSuccess = function(p24) -- line: 391
			-- upvalues: p22 (copy), SetPlayerIsBlocked (copy)
			p22(SetPlayerIsBlocked(p24, true))
		end,
		unblockPlayer = function(p25) -- line: 395
			-- upvalues: p22 (copy), UnblockPlayer (copy)
			return p22(UnblockPlayer(p25))
		end,
		requestFriendship = function(p26, _) -- line: 399
			-- upvalues: p22 (copy), RequestFriendship (copy)
			return p22(RequestFriendship(p26))
		end
	}
end
local function PlayerDropDownWrapper(p28) -- line: 405
	-- upvalues: useLayoutValues (copy), ReactFocusNavigation (copy), Roact (copy), v35 (copy), Cryo (copy)
	local v78 = useLayoutValues()
	local v79 = ReactFocusNavigation.useFocusGuiObject()
	local v80 = ReactFocusNavigation.useFocusedGuiObject()

	return Roact.createElement(v35, Cryo.Dictionary.join(p28, {
		focusGuiObject = v79,
		focusedGuiObject = v80,
		layoutValues = v78
	}))
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerDropDownWrapper))
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerDropDownWrapper)
