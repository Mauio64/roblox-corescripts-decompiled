local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local UIBlox = require(CorePackages.Packages.UIBlox)

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
local FFlagPlayerListReduceRerenders = require(parent2.Flags.FFlagPlayerListReduceRerenders)

local UnblockPlayer = require(parent2.Thunks.UnblockPlayer)
local RequestFriendship = require(parent2.Thunks.RequestFriendship)
local SetPlayerIsBlocked = require(parent2.Actions.SetPlayerIsBlocked)

local extended = Roact.PureComponent:extend("PlayerDropDown")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagStandardizeSafetyIcon = SharedFlags.FFlagStandardizeSafetyIcon
local FFlagAllowDisplayingFoundationIconsForDropdown = require(parent2.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

extended.validateProps = t.strictInterface({
	positionY = t.number,
	minPositionBoundY = t.number,
	maxPositionBoundY = t.number,
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
	subjectToChinaPolicies = t.boolean,
	closeDropDown = t.callback,
	blockPlayerSuccess = t.callback,
	unblockPlayer = t.callback,
	requestFriendship = t.callback
})

function extended:init()
	self.innerFrameRef = Roact.createRef()

	self.motorOptions = { dampingRatio = 1, frequency = 4 }

	self.motor = Otter.createSingleMotor(1)
	self.motor:onStep(function(p)
		local current = self.innerFrameRef.current

		if current then
			if p == 1 then
				current.Visible = false
			else
				current.Visible = true
			end

			current.Position = UDim2.new(p, 0, 0, 0)
		end
	end)

	self.dropDownPosition = 0
end

function extended:createFriendButton(playerRelationship)
	local selectedPlayer = self.props.selectedPlayer
	return Roact.createElement(FriendDropDownButton, {
		layoutOrder = 1,
		playerRelationship = playerRelationship,
		selectedPlayer = selectedPlayer,
		dropDownOpen = self.props.isVisible,
		requestFriendship = self.props.requestFriendship,
		contentVisible = true
	})
end

function extended:createBlockButton(p)
	local selectedPlayer = self.props.selectedPlayer
	local text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Block")
	local formatByKey = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.UnBlock")
	local iconsactionsblock = Images["icons/actions/block"]

	local createElement = Roact.createElement

	text = p.isBlocked and formatByKey or text
	return createElement(DropDownButton, {
		layoutOrder = 4,
		text = text,
		icon = iconsactionsblock,
		lastButton = false,
		forceShowOptions = false,
		onActivated = function()
			if p.isBlocked then
				self.props.unblockPlayer(selectedPlayer)
			else
				onBlockButtonActivated(selectedPlayer, nil, self.__componentName, {
					onBlockingSuccess = function()
						self.props.blockPlayerSuccess(selectedPlayer)
					end
				})
			end
		end
	})
end

function extended:createReportButton()
	local selectedPlayer = self.props.selectedPlayer

	local icon = FFlagStandardizeSafetyIcon and FFlagAllowDisplayingFoundationIconsForDropdown and "Flag"
		or Images["icons/actions/feedback"]

	return Roact.createElement(DropDownButton, {
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
		layoutOrder = 3,
		text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Examine"),
		icon = iconsactionszoomIn,
		lastButton = selectedPlayer == LocalPlayer,
		forceShowOptions = false,
		onActivated = function()
			GuiService:InspectPlayerFromUserIdWithCtx(selectedPlayer.UserId, "leaderBoard")
			self.props.closeDropDown()
		end
	})
end

function extended:render()
	return WithLayoutValues(function(props)
		local selectedPlayer = self.props.selectedPlayer

		if not selectedPlayer or self.props.isTenFootInterface then
			return nil
		end

		local children = {}

		children.UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, props.DropDownButtonPadding),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		children.PlayerHeader = Roact.createElement(DropDownPlayerHeader, {
			player = self.props.selectedPlayer
		})

		local v = props.DropDownButtonPadding + props.DropDownHeaderSizeY

		local playerRelationship = self.props.playerRelationship

		if selectedPlayer ~= LocalPlayer then
			if not playerRelationship.isBlocked then
				children.FriendButton = self:createFriendButton(playerRelationship)
				v = v + props.DropDownButtonPadding + props.DropDownButtonSizeY
			end

			children.BlockButton = self:createBlockButton(playerRelationship)
			local v2 = v + props.DropDownButtonPadding + props.DropDownButtonSizeY

			children.ReportButton = self:createReportButton()
			v = v2 + props.DropDownButtonPadding + props.DropDownButtonSizeY
		end

		if self.props.inspectMenuEnabled then
			children.InspectButton = self:createInspectButton()
			v = v + props.DropDownButtonPadding + props.DropDownButtonSizeY
		end

		local v2 = v - props.DropDownButtonPadding

		local v3 = self.dropDownPosition + (props.DropDownHeaderBackgroundSize - props.DropDownHeaderSizeY)

		if v3 + v2 > self.props.maxPositionBoundY then
			v3 -= v3 + v2 - self.props.maxPositionBoundY
		elseif v3 < self.props.minPositionBoundY then
			v3 += self.props.minPositionBoundY - v3
		end

		return Roact.createElement("Frame", {
			LayoutOrder = self.props.layoutOrder,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(0, 0, 0, v3),
			Size = UDim2.new(0, props.PlayerDropDownSizeX + props.PlayerDropDownOffset, 0, v2),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		}, {
			InnerFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, -props.PlayerDropDownOffset, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Roact.Ref] = self.innerFrameRef
			}, children)
		})
	end)
end

function extended:getDropDownPosition(): number
	if self.props.isVisible and self.props.contentsVisible then
		return 0
	end

	return 1
end

function extended:didMount()
	local dropDownPosition = self:getDropDownPosition()
	self.motor:start()
	self.motor:setGoal(Otter.spring(dropDownPosition, self.motorOptions))
end

function extended:willUpdate(p, _)
	self.dropDownPosition = p.positionY
end

function extended:didUpdate(p, _)
	if p.selectedPlayer ~= self.props.selectedPlayer then
		self.motor:setGoal(Otter.instant(1))
		self.motor:step(0)
	end

	local dropDownPosition = self:getDropDownPosition()
	self.motor:setGoal(Otter.spring(dropDownPosition, self.motorOptions))
end

function extended.willUnmount(p)
	p.motor:destroy()
end

local function mapStateToProps(data)
	local selectedPlayer = data.playerDropDown.selectedPlayer
	return {
		selectedPlayer = selectedPlayer,
		isVisible = data.playerDropDown.isVisible and data.displayOptions.isVisible,
		playerRelationship = selectedPlayer and data.playerRelationship[selectedPlayer.UserId],
		inspectMenuEnabled = data.displayOptions.inspectMenuEnabled,
		isTenFootInterface = data.displayOptions.isTenFootInterface,
		subjectToChinaPolicies = data.displayOptions.subjectToChinaPolicies
	}
end

local function mapDispatchToProps(callback)
	return {
		closeDropDown = function()
			return callback(ClosePlayerDropDown())
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

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
