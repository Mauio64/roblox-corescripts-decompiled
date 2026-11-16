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

local parent = script.Parent.Parent
local connection = parent.Connection
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local DropDownButton = require(script.Parent.DropDownButton)
local DropDownPlayerHeader = require(script.Parent.DropDownPlayerHeader)
local FriendDropDownButton = require(script.Parent.FriendDropDownButton)

local LocalPlayer = Players.LocalPlayer

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local onBlockButtonActivated = require(RobloxGui.Modules.Settings.onBlockButtonActivated)

local Images = UIBlox.App.ImageSet.Images

local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)

local parent2 = parent.Parent

local ClosePlayerDropDown = require(parent2.Actions.ClosePlayerDropDown)
local SetPlayerListVisibility = require(parent2.Actions.SetPlayerListVisibility)
local FFlagPlayerListReduceRerenders = require(parent2.Flags.FFlagPlayerListReduceRerenders)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav

local UnblockPlayer = require(parent2.Thunks.UnblockPlayer)
local RequestFriendship = require(parent2.Thunks.RequestFriendship)
local SetPlayerIsBlocked = require(parent2.Actions.SetPlayerIsBlocked)

local extended = Roact.PureComponent:extend("PlayerDropDown")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagStandardizeSafetyIcon = SharedFlags.FFlagStandardizeSafetyIcon
local FFlagAllowDisplayingFoundationIconsForDropdown = require(parent2.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

extended.validateProps = t.strictInterface({
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

local v = { dampingRatio = 1, frequency = 4 }

function extended:init()
	self.state = { allVisible = false, contentVisible = false }

	self.buttonsContainerRef = React.createRef()

	local binding, updateContainerScale = Roact.createBinding(1)
	self.containerScale = binding
	self.updateContainerScale = updateContainerScale
	self.containerScaleMotor = Otter.createSingleMotor(0)
	self.containerScaleMotor:onStep(function(p)
		self.updateContainerScale(p)
	end)

	local binding2, updateTransparency = Roact.createBinding(1)
	self.transparency = binding2
	self.updateTransparency = updateTransparency
	self.transparencyMotor = Otter.createSingleMotor(0)
	self.transparencyMotor:onStep(function(p)
		self.updateTransparency(p)

		if p < 0.5 and self.props.isVisible and self.props.contentsVisible then
			self:setState({ contentVisible = true })
		else
			self:setState({ contentVisible = false })
		end

		self:setState({
			allVisible = p < 1
		})
	end)

	local binding3, updateButtonTransparency = Roact.createBinding(1)
	self.buttonTransparency = binding3
	self.updateButtonTransparency = updateButtonTransparency
	self.buttonTransparencyMotor = Otter.createSingleMotor(0)
	self.buttonTransparencyMotor:onStep(function(p)
		self.updateButtonTransparency(p)
	end)
end

function extended:createFriendButton(playerRelationship)
	local selectedPlayer = self.props.selectedPlayer
	return Roact.createElement(FriendDropDownButton, {
		layoutOrder = 1,
		playerRelationship = playerRelationship,
		selectedPlayer = selectedPlayer,
		dropDownOpen = self.props.isVisible,
		requestFriendship = self.props.requestFriendship,
		contentVisible = self.state.contentVisible,
		isUsingGamepad = self.props.isUsingGamepad
	})
end

function extended:createBlockButton(p)
	local selectedPlayer = self.props.selectedPlayer
	local text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Block")
	local formatByKey = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.UnBlock")
	local iconsactionsblock = Images["icons/actions/block"]

	local createElement = Roact.createElement
	local v2 = {
		contentVisible = self.state.contentVisible,
		buttonTransparency = self.buttonTransparency,
		layoutOrder = 4,
		text = 0,
		icon = 0,
		lastButton = false,
		forceShowOptions = false,
		onActivated = 0
	}

	text = p.isBlocked and formatByKey or text
	v2.text = text
	v2.icon = iconsactionsblock

	function v2.onActivated()
		if p.isBlocked then
			self.props.unblockPlayer(selectedPlayer)
		else
			onBlockButtonActivated(selectedPlayer, nil, self.__componentName, {
				onBlockingSuccess = function()
					self.props.blockPlayerSuccess(selectedPlayer)
				end,
				onBlockingModalClose = FFlagAddNewPlayerListMobileFocusNav and function()
					if self.props.isUsingGamepad then
						self.props.focusGuiObject(self.buttonsContainerRef.current)
					end
				end or nil
			})
		end
	end

	return createElement(DropDownButton, v2)
end

function extended:createReportButton()
	local selectedPlayer = self.props.selectedPlayer

	local icon = FFlagStandardizeSafetyIcon and FFlagAllowDisplayingFoundationIconsForDropdown and "Flag"
		or Images["icons/actions/feedback"]

	return Roact.createElement(DropDownButton, {
		contentVisible = self.state.contentVisible,
		buttonTransparency = self.buttonTransparency,
		layoutOrder = 5,
		text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Report"),
		icon = icon,
		lastButton = true,
		forceShowOptions = false,
		onActivated = function()
			if isNewInGameMenuEnabled() then
				local InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
				InGameMenuInit.openReportDialog(selectedPlayer, self.__componentName)
			else
				local ReportAbuseMenuContainerPage = require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuContainerPage)
				ReportAbuseMenuContainerPage:ReportPlayer(selectedPlayer, self.__componentName)
				self.props.closeDropDown()
			end
		end
	})
end

function extended:createInspectButton()
	local selectedPlayer = self.props.selectedPlayer
	local iconsactionszoomIn = Images["icons/actions/zoomIn"]

	return Roact.createElement(DropDownButton, {
		contentVisible = self.state.contentVisible,
		buttonTransparency = self.buttonTransparency,
		layoutOrder = 3,
		text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Examine"),
		icon = iconsactionszoomIn,
		lastButton = selectedPlayer == LocalPlayer,
		forceShowOptions = false,
		onActivated = function()
			GuiService:InspectPlayerFromUserIdWithCtx(selectedPlayer.UserId, "leaderBoard")
			self.props.closeDropDown()
			self.props.setPlayerListVisibility(false)
		end
	})
end

function extended:render()
	return WithLayoutValues(function(_)
		local layoutValues = self.props.layoutValues

		local selectedPlayer = self.props.selectedPlayer

		if not selectedPlayer or self.props.isTenFootInterface then
			return nil
		end

		local children = {}

		children.UIScale = Roact.createElement("UIScale", { Scale = self.containerScale })

		children.UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, layoutValues.DropDownButtonPadding),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		children.PlayerHeader = Roact.createElement(DropDownPlayerHeader, {
			player = self.props.selectedPlayer,
			contentVisible = self.state.contentVisible,
			transparency = self.transparency
		})

		local v2 = 4 * layoutValues.DropDownButtonSizeY + layoutValues.DropDownHeaderSizeY
		local v3 = layoutValues.DropDownButtonPadding + layoutValues.DropDownHeaderSizeY

		local playerRelationship = self.props.playerRelationship

		if selectedPlayer ~= LocalPlayer then
			if not playerRelationship.isBlocked then
				children.FriendButton = self:createFriendButton(playerRelationship)
				v3 = v3 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY
			end

			children.BlockButton = self:createBlockButton(playerRelationship)
			local v4 = v3 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY

			children.ReportButton = self:createReportButton()
			v3 = v4 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY
		end

		if self.props.inspectMenuEnabled then
			children.InspectButton = self:createInspectButton()
			v3 = v3 + layoutValues.DropDownButtonPadding + layoutValues.DropDownButtonSizeY
		end

		local v4 = v3 - layoutValues.DropDownButtonPadding

		local createElement = Roact.createElement
		local v5 = {
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			LayoutOrder = self.props.layoutOrder,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Selectable = false,
			Modal = false,
			Visible = self.state.allVisible,
			AutoButtonColor = false,
			Active = self.props.isVisible,
			Image = "",
			SelectionGroup = FFlagAddNewPlayerListMobileFocusNav and true or nil
		}
		local selectionBehaviorUp

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorUp = Enum.SelectionBehavior.Stop
		end

		v5.SelectionBehaviorUp = selectionBehaviorUp
		local selectionBehaviorDown

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorDown = Enum.SelectionBehavior.Stop
		end

		v5.SelectionBehaviorDown = selectionBehaviorDown
		local selectionBehaviorLeft

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorLeft = Enum.SelectionBehavior.Stop
		end

		v5.SelectionBehaviorLeft = selectionBehaviorLeft
		local selectionBehaviorRight

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorRight = Enum.SelectionBehavior.Stop
		end

		v5.SelectionBehaviorRight = selectionBehaviorRight
		v5[Roact.Event.Activated] = self.props.closeDropDown
		v5[Roact.Ref] = self.imageButtonRef

		local createElement2 = Roact.createElement
		local v6 = {
			["LayoutOrder"] = self.props.layoutOrder,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.5, -v2 / 2),
			Size = UDim2.new(0, layoutValues.PlayerDropDownSizeXMobile, 0, v4),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		}

		local ref = Roact.Ref
		local v7

		if FFlagAddNewPlayerListMobileFocusNav then
			v7 = self.buttonsContainerRef
		end

		v6[ref] = v7
		return createElement("ImageButton", v5, {
			Container = createElement2("Frame", v6, children)
		})
	end)
end

function extended:getScale(): number
	if self.props.isVisible and self.props.contentsVisible then
		return 1
	end

	return 1.25
end

function extended:getTransparency(): number
	if self.props.isVisible and self.props.contentsVisible then
		return 0
	end

	return 1
end

function extended:getButtonTransparency()
	if self.props.isVisible and self.props.contentsVisible then
		return self.props.preferredTransparency * 0.3
	end

	return 1
end

function extended:didUpdate(_, p)
	self.containerScaleMotor:setGoal(Otter.spring(self:getScale(), v))
	self.transparencyMotor:setGoal(Otter.spring(self:getTransparency(), v))
	self.buttonTransparencyMotor:setGoal(Otter.spring(self:getButtonTransparency(), v))

	if
		FFlagAddNewPlayerListMobileFocusNav
		and self.props.isUsingGamepad
		and (p.contentVisible ~= self.state.contentVisible or not self.props.focusedGuiObject)
		and self.state.contentVisible
		and self.buttonsContainerRef.current
	then
		self.props.focusGuiObject(self.buttonsContainerRef.current)

		if not FFlagAddNewPlayerListMobileFocusNav then
			self.buttonsContainerRef.current.SelectionGroup = true
			self.buttonsContainerRef.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			self.buttonsContainerRef.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			self.buttonsContainerRef.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			self.buttonsContainerRef.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		end
	end
end

function extended.didMount(_) end

function extended:willUnmount()
	self.transparencyMotor:destroy()
	self.containerScaleMotor:destroy()
	self.buttonTransparencyMotor:destroy()

	self.transparencyMotor = nil
	self.containerScaleMotor = nil
	self.buttonTransparencyMotor = nil
end

local function mapStateToProps(data)
	local selectedPlayer = data.playerDropDown.selectedPlayer

	local v2 = {
		selectedPlayer = selectedPlayer,
		isVisible = data.playerDropDown.isVisible and data.displayOptions.isVisible,
		playerRelationship = selectedPlayer and data.playerRelationship[selectedPlayer.UserId],
		inspectMenuEnabled = data.displayOptions.inspectMenuEnabled,
		isTenFootInterface = data.displayOptions.isTenFootInterface,
		isUsingGamepad = 0,
		subjectToChinaPolicies = 0,
		preferredTransparency = 0
	}
	local isUsingGamepad

	if FFlagAddNewPlayerListMobileFocusNav then
		isUsingGamepad = data.displayOptions.isUsingGamepad
	end

	v2.isUsingGamepad = isUsingGamepad
	v2.subjectToChinaPolicies = data.displayOptions.subjectToChinaPolicies
	v2.preferredTransparency = data.settings.preferredTransparency
	return v2
end

local function mapDispatchToProps(callback)
	return {
		closeDropDown = function()
			return callback(ClosePlayerDropDown())
		end,
		setPlayerListVisibility = function(p)
			return callback(SetPlayerListVisibility(p))
		end,
		blockPlayerSuccess = function(p)
			callback(SetPlayerIsBlocked(p, true))
		end,
		unblockPlayer = function(p)
			return callback(UnblockPlayer(p))
		end,
		requestFriendship = function(p, _)
			return callback(RequestFriendship(p))
		end
	}
end

local function PlayerDropDownWrapper(p)
	local layoutValues = useLayoutValues()

	local focusGuiObject = ReactFocusNavigation.useFocusGuiObject()
	local focusedGuiObject = ReactFocusNavigation.useFocusedGuiObject()

	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p, {
			focusGuiObject = focusGuiObject,
			focusedGuiObject = focusedGuiObject,
			layoutValues = layoutValues
		})
	)
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerDropDownWrapper))
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerDropDownWrapper)
