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
local FFlagPlayerListReduceRerenders = require(ParentParentParent.Flags.FFlagPlayerListReduceRerenders)
local UnblockPlayer = require(ParentParentParent.Thunks.UnblockPlayer)
local RequestFriendship = require(ParentParentParent.Thunks.RequestFriendship)
local SetPlayerIsBlocked = require(ParentParentParent.Actions.SetPlayerIsBlocked)
local v29 = Roact.PureComponent:extend("PlayerDropDown")
local FFlagStandardizeSafetyIcon = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStandardizeSafetyIcon
local FFlagAllowDisplayingFoundationIconsForDropdown = require(ParentParentParent.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

v29.validateProps = t.strictInterface({
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

function v29.init(p1) -- line: 73
	-- upvalues: Roact (copy), Otter (copy)
	p1.innerFrameRef = Roact.createRef()
	p1.motorOptions = {
		dampingRatio = 1,
		frequency = 4
	}
	p1.motor = Otter.createSingleMotor(1)
	p1.motor:onStep(function(p2) -- line: 83
		-- upvalues: p1 (copy)
		local current = p1.innerFrameRef.current

		if current then
			if p2 == 1 then
				current.Visible = false
			else
				current.Visible = true
			end

			current.Position = UDim2.new(p2, 0, 0, 0)
		end
	end)
	p1.dropDownPosition = 0
end
function v29.createFriendButton(p3, p4) -- line: 99
	-- upvalues: Roact (copy), FriendDropDownButton (copy)
	local selectedPlayer = p3.props.selectedPlayer

	return Roact.createElement(FriendDropDownButton, {
		layoutOrder = 1,
		contentVisible = true,
		playerRelationship = p4,
		selectedPlayer = selectedPlayer,
		dropDownOpen = p3.props.isVisible,
		requestFriendship = p3.props.requestFriendship
	})
end
function v29.createBlockButton(p5, p6) -- line: 111
	-- upvalues: RobloxTranslator (copy), Images (copy), Roact (copy), DropDownButton (copy), onBlockButtonActivated (copy)
	local selectedPlayer = p5.props.selectedPlayer
	local v41 = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Block")
	local v42 = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.UnBlock")
	local v43 = Images["icons/actions/block"]

	return Roact.createElement(DropDownButton, {
		layoutOrder = 4,
		lastButton = false,
		forceShowOptions = false,
		text = p6.isBlocked and v42 or v41,
		icon = v43,
		onActivated = function() -- line: 123
			-- upvalues: p6 (copy), p5 (copy), selectedPlayer (copy), onBlockButtonActivated (copy)
			if p6.isBlocked then
				p5.props.unblockPlayer(selectedPlayer)

				return
			end

			onBlockButtonActivated(selectedPlayer, nil, p5.__componentName, {
				onBlockingSuccess = function() -- line: 128
					-- upvalues: p5 (copy), selectedPlayer (copy)
					p5.props.blockPlayerSuccess(selectedPlayer)
				end
			})
		end
	})
end
function v29.createReportButton(p7) -- line: 137
	-- upvalues: FFlagStandardizeSafetyIcon (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), Images (copy), Roact (copy), DropDownButton (copy), RobloxTranslator (copy), isNewInGameMenuEnabled (copy), RobloxGui (copy)
	local selectedPlayer = p7.props.selectedPlayer
	local v46 = if not FFlagStandardizeSafetyIcon or not FFlagAllowDisplayingFoundationIconsForDropdown then Images["icons/actions/feedback"] else "Flag"

	return Roact.createElement(DropDownButton, {
		layoutOrder = 5,
		lastButton = true,
		forceShowOptions = false,
		text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Report"),
		icon = v46,
		onActivated = function() -- line: 150
			-- upvalues: isNewInGameMenuEnabled (copy), RobloxGui (copy), selectedPlayer (copy), p7 (copy)
			if isNewInGameMenuEnabled() then
				require(RobloxGui.Modules.InGameMenuInit).openReportDialog(selectedPlayer, p7.__componentName)

				return
			end

			require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuNewContainerPage):ReportPlayer(selectedPlayer, p7.__componentName)
			p7.props.closeDropDown()
		end
	})
end
function v29.createInspectButton(p8) -- line: 164
	-- upvalues: Images (copy), Roact (copy), DropDownButton (copy), RobloxTranslator (copy), LocalPlayer (copy), GuiService (copy)
	local selectedPlayer = p8.props.selectedPlayer
	local v49 = Images["icons/actions/zoomIn"]

	return Roact.createElement(DropDownButton, {
		layoutOrder = 3,
		forceShowOptions = false,
		text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.Examine"),
		icon = v49,
		lastButton = selectedPlayer == LocalPlayer,
		onActivated = function() -- line: 174
			-- upvalues: GuiService (copy), selectedPlayer (copy), p8 (copy)
			GuiService:InspectPlayerFromUserIdWithCtx(selectedPlayer.UserId, "leaderBoard")
			p8.props.closeDropDown()
		end
	})
end
function v29.render(p9) -- line: 181
	-- upvalues: WithLayoutValues (copy), Roact (copy), DropDownPlayerHeader (copy), LocalPlayer (copy)
	return WithLayoutValues(function(p10) -- line: 182
		-- upvalues: p9 (copy), Roact (copy), DropDownPlayerHeader (copy), LocalPlayer (copy)
		local selectedPlayer = p9.props.selectedPlayer

		if not selectedPlayer or p9.props.isTenFootInterface then
			return nil
		end

		local t1 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, p10.DropDownButtonPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			PlayerHeader = Roact.createElement(DropDownPlayerHeader, {
				player = p9.props.selectedPlayer
			})
		}
		local v71 = p10.DropDownButtonPadding + p10.DropDownHeaderSizeY
		local playerRelationship = p9.props.playerRelationship

		if selectedPlayer ~= LocalPlayer then
			if not playerRelationship.isBlocked then
				t1.FriendButton = p9:createFriendButton(playerRelationship)
				v71 = v71 + p10.DropDownButtonPadding + p10.DropDownButtonSizeY
			end

			t1.BlockButton = p9:createBlockButton(playerRelationship)

			local v73 = v71 + p10.DropDownButtonPadding + p10.DropDownButtonSizeY

			t1.ReportButton = p9:createReportButton()
			v71 = v73 + p10.DropDownButtonPadding + p10.DropDownButtonSizeY
		end

		if p9.props.inspectMenuEnabled then
			t1.InspectButton = p9:createInspectButton()
			v71 = v71 + p10.DropDownButtonPadding + p10.DropDownButtonSizeY
		end

		local v74 = v71 - p10.DropDownButtonPadding
		local v75 = p9.dropDownPosition + (p10.DropDownHeaderBackgroundSize - p10.DropDownHeaderSizeY)

		if v75 + v74 > p9.props.maxPositionBoundY then
			v75 -= v75 + v74 - p9.props.maxPositionBoundY
		elseif v75 < p9.props.minPositionBoundY then
			v75 += p9.props.minPositionBoundY - v75
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = p9.props.layoutOrder,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(0, 0, 0, v75),
			Size = UDim2.new(0, p10.PlayerDropDownSizeX + p10.PlayerDropDownOffset, 0, v74)
		}, {
			InnerFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, -p10.PlayerDropDownOffset, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Roact.Ref] = p9.innerFrameRef
			}, t1)
		})
	end)
end
function v29.getDropDownPosition(p11) -- line: 256
	if p11.props.isVisible and p11.props.contentsVisible then
		return 0
	end

	return 1
end
function v29.didMount(p12) -- line: 263
	-- upvalues: Otter (copy)
	local v53 = p12:getDropDownPosition()

	p12.motor:start()
	p12.motor:setGoal(Otter.spring(v53, p12.motorOptions))
end
function v29.willUpdate(p13, p14, _) -- line: 269
	p13.dropDownPosition = p14.positionY
end
function v29.didUpdate(p16, p17, _) -- line: 273
	-- upvalues: Otter (copy)
	if p17.selectedPlayer ~= p16.props.selectedPlayer then
		p16.motor:setGoal(Otter.instant(1))
		p16.motor:step(0)
	end

	local v60 = p16:getDropDownPosition()

	p16.motor:setGoal(Otter.spring(v60, p16.motorOptions))
end
function v29.willUnmount(p19) -- line: 283
	p19.motor:destroy()
end

local function mapStateToProps(p20) -- line: 287
	local selectedPlayer = p20.playerDropDown.selectedPlayer
	local v64 = p20.playerDropDown.isVisible and p20.displayOptions.isVisible

	return {
		selectedPlayer = selectedPlayer,
		isVisible = v64,
		playerRelationship = selectedPlayer and p20.playerRelationship[selectedPlayer.UserId],
		inspectMenuEnabled = p20.displayOptions.inspectMenuEnabled,
		isTenFootInterface = p20.displayOptions.isTenFootInterface,
		subjectToChinaPolicies = p20.displayOptions.subjectToChinaPolicies
	}
end
local function mapDispatchToProps(p21) -- line: 301
	-- upvalues: ClosePlayerDropDown (copy), SetPlayerIsBlocked (copy), UnblockPlayer (copy), RequestFriendship (copy)
	return {
		closeDropDown = function() -- line: 303
			-- upvalues: p21 (copy), ClosePlayerDropDown (copy)
			return p21(ClosePlayerDropDown())
		end,
		blockPlayerSuccess = function(p22) -- line: 307
			-- upvalues: p21 (copy), SetPlayerIsBlocked (copy)
			p21(SetPlayerIsBlocked(p22, true))
		end,
		unblockPlayer = function(p23) -- line: 311
			-- upvalues: p21 (copy), UnblockPlayer (copy)
			return p21(UnblockPlayer(p23))
		end,
		requestFriendship = function(p24, _) -- line: 315
			-- upvalues: p21 (copy), RequestFriendship (copy)
			return p21(RequestFriendship(p24))
		end
	}
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v29))
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v29)
