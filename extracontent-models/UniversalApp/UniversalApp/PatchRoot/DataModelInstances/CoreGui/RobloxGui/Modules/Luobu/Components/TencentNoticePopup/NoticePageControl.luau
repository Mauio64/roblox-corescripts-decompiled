local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Modules = CoreGui.RobloxGui.Modules
local withStyle = UIBlox.Style.withStyle
local EventConnection = ReactUtils.EventConnection
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local DecrementUnreadTencentNoticeCount = require(Modules.Luobu.Actions.DecrementUnreadTencentNoticeCount)
local ReadTencentNoticeId = require(Modules.Luobu.Actions.ReadTencentNoticeId)
local NoticePageControlItem = require(Modules.Luobu.Components.TencentNoticePopup.NoticePageControlItem)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local MemStorageKeys = require(Modules.Luobu.Enum.MemStorageKeys)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local t1 = {
	dampingRatio = 1,
	frequency = 10
}
local v23 = Roact.PureComponent:extend("NoticePageControl")

v23.validateProps = t.strictInterface({
	noticeList = t.table,
	onActivated = t.callback,
	settings = t.strictInterface({
		widePopupWidth = t.number,
		widePopupHeight = t.number,
		headerHeight = t.number,
		bottomHeight = t.number,
		compactHeightToWidthRatio = t.number
	}),
	formFactor = t.string,
	screenSize = t.Vector2,
	openNoticeDetail = t.callback,
	decrementUnreadTencentNoticeCount = t.callback,
	readTencentNoticeId = t.callback
})

function v23.checkInsidePage(p1, p2, p3) -- line: 59
	-- upvalues: FormFactor (copy)
	local formFactor = p1.props.formFactor
	local screenSizeX = p1.props.screenSize.X
	local screenSizeY = p1.props.screenSize.Y
	local bottomHeight = p1.props.settings.bottomHeight

	if formFactor == FormFactor.WIDE then
		local v34 = (screenSizeX - p1.props.settings.widePopupWidth) / 2
		local v35 = (screenSizeY - p1.props.settings.widePopupWidth) / 2

		if p2 < v34 or p2 > screenSizeX - v34 then
			return false
		end

		if p3 < v35 or p3 > screenSizeY - v35 - bottomHeight then
			return false
		end
	else
		if p2 < 24 or p2 > screenSizeX - 24 then
			return false
		end

		local v36 = (screenSizeY - p1.topHeight) / 2

		if p3 < v36 or p3 > screenSizeY - v36 - bottomHeight then
			return false
		end
	end

	return true
end
function v23.init(p4) -- line: 86
	-- upvalues: Roact (copy), MemStorageService (copy), MemStorageKeys (copy), HttpService (copy), FormFactor (copy), Otter (copy), t1 (copy)
	p4.state = {
		selectedValue = 1
	}

	local v38, v39 = Roact.createBinding(0)

	p4.positionX = v38
	p4.updatePositionX = v39

	function p4.touchTapCallback(p5) -- line: 91
		-- upvalues: p4 (copy), MemStorageService (copy), MemStorageKeys (copy), HttpService (copy), FormFactor (copy), Otter (copy), t1 (copy)
		local v68 = p4.props.noticeList[p4.state.selectedValue]

		if v68.noticeUrl == nil then
			return
		end

		local X = p5[1].X
		local Y = p5[1].Y

		if p4:checkInsidePage(X, Y) == false then
			return
		end

		local title = p4.props.noticeList[p4.state.selectedValue].title

		p4.props.openNoticeDetail(v68.noticeUrl, title)

		if v68.hasRead == false then
			MemStorageService:Fire(MemStorageKeys.TencentNoticeIdReadStatus, HttpService:JSONEncode({
				noticeId = v68.noticeId,
				endTime = v68.endTime
			}))
		end

		p4.props.decrementUnreadTencentNoticeCount()
		p4.props.readTencentNoticeId(v68.noticeId)

		local selectedValue = p4.state.selectedValue

		if selectedValue == #p4.props.noticeList then
			p4.props.onActivated()

			return
		end

		local widePopupWidth = p4.props.settings.widePopupWidth
		local v74 = (p4.props.formFactor == FormFactor.WIDE and widePopupWidth or p4.compactWidth) * selectedValue

		p4:setState({
			selectedValue = selectedValue + 1
		})
		p4.motor:setGoal(Otter.spring(v74, t1))
	end

	p4.goalLocation = 0
	p4.compactWidth = p4.props.screenSize.X - 48

	function p4.touchMoveCallback(p6) -- line: 135
		-- upvalues: p4 (copy), FormFactor (copy), Otter (copy), t1 (copy)
		local PositionX = p6.Position.X
		local PositionY = p6.Position.Y

		if p4.isMoving or p4:checkInsidePage(PositionX, PositionY) == false then
			return
		end

		local v78 = p4.props.formFactor == FormFactor.WIDE
		local widePopupWidth = p4.props.settings.widePopupWidth
		local v80 = v78 and widePopupWidth or p4.compactWidth

		if math.abs(p6.Delta.X) > 20 then
			local v81 = math.sign(p6.Delta.X)
			local v82 = math.clamp(p4.state.selectedValue - v81, 1, #p4.props.noticeList)

			p4:setState({
				selectedValue = v82
			})

			local v83 = v80 * (v82 - 1)

			p4.motor:setGoal(Otter.spring(v83, t1))
			p4.goalLocation = v83
			p4.isMoving = true
		end
	end

	p4.motor = Otter.createSingleMotor(1)
	p4.motor:onStep(function(n1: number) -- line: 161
		-- upvalues: p4 (copy)
		local v85 = math.abs(n1 - p4.goalLocation)

		if v85 == 0 then
			return
		end

		if v85 < 1 then
			p4.updatePositionX(p4.goalLocation)

			return
		end

		p4.updatePositionX(n1)
	end)
	p4.motor:onComplete(function() -- line: 172
		-- upvalues: p4 (copy)
		p4.isMoving = false
	end)
end
function v23.didMount(p7) -- line: 177
	if p7.props.onMounted then
		p7.props.onMounted()
	end
end
function v23.willUnmount(p8) -- line: 183
	if p8.motor then
		p8.motor:destroy()
	end
end
function v23.render(p9) -- line: 189
	-- upvalues: FormFactor (copy), Roact (copy), NoticePageControlItem (copy), withStyle (copy), EventConnection (copy), UserInputService (copy), DEPRECATED_ImageSetButton (copy)
	local widePopupWidth, widePopupHeight

	if p9.props.formFactor == FormFactor.WIDE then
		widePopupWidth = p9.props.settings.widePopupWidth
		widePopupHeight = p9.props.settings.widePopupHeight
	else
		widePopupWidth = p9.compactWidth
		widePopupHeight = widePopupWidth * p9.props.settings.compactHeightToWidthRatio
	end

	local v45 = #p9.props.noticeList * widePopupWidth
	local bottomHeight = p9.props.settings.bottomHeight
	local headerHeight = p9.props.settings.headerHeight
	local v48 = headerHeight + widePopupHeight + bottomHeight
	local v49 = #p9.props.noticeList == 1

	p9.topHeight = headerHeight + widePopupHeight

	local t2 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})
	}

	for i, v in ipairs(p9.props.noticeList) do
		t2["NoticePageControlItem" .. i] = Roact.createElement(NoticePageControlItem, {
			headerHeight = headerHeight,
			contentHeight = widePopupHeight,
			width = widePopupWidth,
			notice = v,
			layoutOrder = i,
			hasOneNotice = v49
		})
	end

	return withStyle(function(p10) -- line: 222
		-- upvalues: Roact (copy), widePopupWidth (ref), v48 (copy), p9 (copy), headerHeight (copy), widePopupHeight (ref), EventConnection (copy), UserInputService (copy), v45 (copy), t2 (copy), bottomHeight (copy), DEPRECATED_ImageSetButton (copy)
		local Theme = p10.Theme

		return Roact.createElement("ImageLabel", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(widePopupWidth, v48),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}, {
			TopFrame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 0,
				ClipsDescendants = true,
				Size = UDim2.fromOffset(widePopupWidth, p9.topHeight)
			}, {
				PageIndicator = p9:renderIndicator(Theme, widePopupWidth, headerHeight, widePopupHeight),
				TouchMoved = Roact.createElement(EventConnection, {
					event = UserInputService.TouchMoved,
					callback = p9.touchMoveCallback
				}),
				TouchTap = Roact.createElement(EventConnection, {
					ZIndex = 2,
					event = UserInputService.TouchTap,
					callback = p9.touchTapCallback
				}),
				ScrollingList = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					BackgroundColor3 = Theme.BackgroundDefault.Color,
					Size = UDim2.fromOffset(v45, headerHeight + widePopupHeight),
					Position = p9.positionX:map(function(p11) -- line: 250
						return UDim2.fromOffset(-p11, 0)
					end)
				}, t2)
			}),
			BottomFrame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.fromOffset(widePopupWidth, bottomHeight),
				Position = UDim2.new(0, 0, 1, 0)
			}, {
				CloseButton = Roact.createElement(DEPRECATED_ImageSetButton, {
					Size = UDim2.fromOffset(48, 48),
					Position = UDim2.new(0.5, -24, 0.5, -24),
					Image = "LuaApp/icons/Luobu/close-circle",
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = p9.props.onActivated
				})
			})
		})
	end)
end

local function createIndicator(p12, p13) -- line: 277
	-- upvalues: Roact (copy)
	local v55 = Roact.createElement("ImageLabel", {
		ZIndex = 3,
		BorderSizePixel = 0,
		BackgroundColor3 = p12.Divider.Color,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = p13
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 4)
		})
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.fromOffset(0.5, 0.5)
	}, v55)
end

function v23.renderIndicator(p14, p15, p16, p17, p18) -- line: 300
	-- upvalues: Roact (copy), createIndicator (copy)
	local v61 = #p14.props.noticeList

	if v61 <= 1 then
		return
	end

	local t3 = {}

	table.insert(t3, (Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})))

	for i = 1, v61 do
		local n2 = 0.7

		if i == p14.state.selectedValue then
			n2 = 0
		end

		table.insert(t3, (createIndicator(p15, n2)))
	end

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 3,
		Size = UDim2.fromOffset(p16, 48),
		Position = UDim2.fromOffset(0, p17 + p18 - 48)
	}, t3)
end

local function mapStateToProps(p19) -- line: 330
	return {
		formFactor = p19.FormFactor,
		screenSize = p19.ScreenSize
	}
end
local function mapDispatchToProps(p20) -- line: 337
	-- upvalues: OpenWebview (copy), DecrementUnreadTencentNoticeCount (copy), ReadTencentNoticeId (copy)
	return {
		openNoticeDetail = function(p21, p22) -- line: 339
			-- upvalues: p20 (copy), OpenWebview (copy)
			p20(OpenWebview(p21, p22))
		end,
		decrementUnreadTencentNoticeCount = function() -- line: 342
			-- upvalues: p20 (copy), DecrementUnreadTencentNoticeCount (copy)
			return p20(DecrementUnreadTencentNoticeCount())
		end,
		readTencentNoticeId = function(p23) -- line: 345
			-- upvalues: p20 (copy), ReadTencentNoticeId (copy)
			return p20(ReadTencentNoticeId(p23))
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v23))
