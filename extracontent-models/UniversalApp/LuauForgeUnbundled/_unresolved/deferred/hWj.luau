local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")
local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local eventConnection = ReactUtils.EventConnection
local module = require("@luauforge/bundled/egM")
local module2 = require("@luauforge/bundled/fzL")
local module3 = require("@luauforge/bundled/geT")
local module4 = require("@luauforge/bundled/geU")
local module5 = require("@luauforge/deferred/hWk")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module6 = require("@luauforge/deferred/geW")

local t = require(CorePackages.Packages.t)

local Otter = require(CorePackages.Packages.Otter)
local v5 = { dampingRatio = 1, frequency = 10 }

local extended = Roact.PureComponent:extend("NoticePageControl")

extended.validateProps = t.strictInterface({
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

function extended:checkInsidePage(p3, p4): boolean
	local formFactor2 = self.props.formFactor
	local x = self.props.screenSize.X
	local y = self.props.screenSize.Y
	local bottomHeight = self.props.settings.bottomHeight

	if formFactor2 == formFactor.WIDE then
		local v6 = (x - self.props.settings.widePopupWidth) / 2
		local v7 = (y - self.props.settings.widePopupWidth) / 2

		if p3 < v6 or x - v6 < p3 or (p4 < v7 or y - v7 - bottomHeight < p4) then
			return false
		end
	else
		if p3 < 24 or x - 24 < p3 then
			return false
		end

		local v6 = (y - self.topHeight) / 2

		if p4 < v6 or y - v6 - bottomHeight < p4 then
			return false
		end
	end

	return true
end

function extended:init()
	self.state = { selectedValue = 1 }

	local binding, v6 = Roact.createBinding(0)
	self.positionX = binding
	self.updatePositionX = v6
	function self.touchTapCallback(list)
		local notice = self.props.noticeList[self.state.selectedValue]

		if not (notice.noticeUrl ~= nil and self:checkInsidePage(list[1].X, list[1].Y) ~= false) then
			return
		end

		local title = self.props.noticeList[self.state.selectedValue].title
		self.props.openNoticeDetail(notice.noticeUrl, title)

		if notice.hasRead == false then
			MemStorageService:Fire(
				module6.TencentNoticeIdReadStatus,
				HttpService:JSONEncode({
					noticeId = notice.noticeId,
					endTime = notice.endTime
				})
			)
		end

		self.props.decrementUnreadTencentNoticeCount()
		self.props.readTencentNoticeId(notice.noticeId)
		local selectedValue = self.state.selectedValue

		if selectedValue == #self.props.noticeList then
			self.props.onActivated()
			return
		end

		local widePopupWidth = self.props.settings.widePopupWidth
		local v7 = (self.props.formFactor == formFactor.WIDE and widePopupWidth or self.compactWidth) * selectedValue
		self:setState({
			selectedValue = selectedValue + 1
		})

		self.motor:setGoal(Otter.spring(v7, v5))
	end
	self.goalLocation = 0
	self.compactWidth = self.props.screenSize.X - 48
	function self.touchMoveCallback(p2)
		local x = p2.Position.X
		local y = p2.Position.Y

		if self.isMoving or self:checkInsidePage(x, y) == false then
			return
		end

		local v7 = self.props.formFactor == formFactor.WIDE
		local widePopupWidth = self.props.settings.widePopupWidth
		local v8 = v7 and widePopupWidth or self.compactWidth

		if math.abs(p2.Delta.X) > 20 then
			local x2 = math.sign(p2.Delta.X)
			local v9 = math.clamp(self.state.selectedValue - x2, 1, #self.props.noticeList)
			self:setState({ selectedValue = v9 })

			local v10 = v8 * (v9 - 1)
			self.motor:setGoal(Otter.spring(v10, v5))
			self.goalLocation = v10
			self.isMoving = true
		end
	end
	self.motor = Otter.createSingleMotor(1)
	self.motor:onStep(function(p2)
		local v7 = math.abs(p2 - self.goalLocation)

		if v7 == 0 then
			return
		end

		if v7 < 1 then
			self.updatePositionX(self.goalLocation)
		else
			self.updatePositionX(p2)
		end
	end)
	self.motor:onComplete(function()
		self.isMoving = false
	end)
end

function extended.didMount(p2)
	if p2.props.onMounted then
		p2.props.onMounted()
	end
end

function extended.willUnmount(p2)
	if p2.motor then
		p2.motor:destroy()
	end
end

function extended:render()
	local v6, v7

	if self.props.formFactor == formFactor.WIDE then
		v6 = self.props.settings.widePopupWidth
		v7 = self.props.settings.widePopupHeight
	else
		v6 = self.compactWidth
		v7 = v6 * self.props.settings.compactHeightToWidthRatio
	end

	local v8 = #self.props.noticeList * v6
	local bottomHeight = self.props.settings.bottomHeight
	local headerHeight = self.props.settings.headerHeight
	local v9 = headerHeight + v7 + bottomHeight
	local v10 = #self.props.noticeList == 1
	self.topHeight = headerHeight + v7
	local children = {}
	children.Layout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center
	})

	for i, notice in ipairs(self.props.noticeList) do
		children["NoticePageControlItem" .. i] = Roact.createElement(module5, {
			headerHeight = headerHeight,
			contentHeight = v7,
			width = v6,
			notice = notice,
			layoutOrder = i,
			hasOneNotice = v10
		})
	end

	return withStyle(function(p2)
		local theme = p2.Theme
		return Roact.createElement("ImageLabel", {
			Size = UDim2.fromOffset(v6, v9),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		}, {
			TopFrame = Roact.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(v6, self.topHeight),
					BorderSizePixel = 0,
					BackgroundTransparency = 0,
					ClipsDescendants = true
				},
				{
					PageIndicator = self:renderIndicator(theme, v6, headerHeight, v7),
					TouchMoved = Roact.createElement(eventConnection, {
						event = UserInputService.TouchMoved,
						callback = self.touchMoveCallback
					}),
					TouchTap = Roact.createElement(eventConnection, {
						event = UserInputService.TouchTap,
						callback = self.touchTapCallback,
						ZIndex = 2
					}),
					ScrollingList = Roact.createElement("Frame", {
						BackgroundColor3 = theme.BackgroundDefault.Color,
						Size = UDim2.fromOffset(v8, headerHeight + v7),
						Position = self.positionX:map(function(p3)
							return UDim2.fromOffset(-p3, 0)
						end),
						BackgroundTransparency = 1,
						ZIndex = 2
					}, children)
				}
			),
			BottomFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.fromOffset(v6, bottomHeight),
				Position = UDim2.new(0, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				CloseButton = Roact.createElement(module, {
					Size = UDim2.fromOffset(48, 48),
					Position = UDim2.new(0.5, -24, 0.5, -24),
					Image = "LuaApp/icons/Luobu/close-circle",
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = self.props.onActivated
				})
			})
		})
	end)
end

local function createIndicator(p2, p3)
	local element = Roact.createElement("ImageLabel", {
		BackgroundColor3 = p2.Divider.Color,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = p3,
		ZIndex = 3,
		BorderSizePixel = 0
	}, {
		UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) })
	})

	return Roact.createElement("Frame", {
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.fromOffset(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 2,
		BorderSizePixel = 0
	}, element)
end

function extended:renderIndicator(p3, p4, p5, p6)
	local count = #self.props.noticeList

	if count <= 1 then
		return
	end

	local v6 = {}
	table.insert(
		v6,
		(Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}))
	)

	for i = 1, count do
		local v7 = i == self.state.selectedValue and 0 or 0.7

		table.insert(v6, (createIndicator(p3, v7)))
	end

	return Roact.createElement("Frame", {
		Size = UDim2.fromOffset(p4, 48),
		Position = UDim2.fromOffset(0, p5 + p6 - 48),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 3
	}, v6)
end

local function mapStateToProps(p2)
	return { formFactor = p2.FormFactor, screenSize = p2.ScreenSize }
end

local function mapDispatchToProps(callback)
	return {
		openNoticeDetail = function(p2, p3)
			callback(module2(p2, p3))
		end,
		decrementUnreadTencentNoticeCount = function()
			return callback(module3())
		end,
		readTencentNoticeId = function(p2)
			return callback(module4(p2))
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))
