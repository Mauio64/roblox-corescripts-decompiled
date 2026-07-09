local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local DateTime = require(CorePackages.Workspace.Packages.Time).DateTime
local TimeZone = require(CorePackages.Workspace.Packages.Time).TimeZone
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local AppPage = require(Modules.LuaApp.AppPage)
local NoticeListCell = require(Modules.Luobu.Components.More.TencentNoticeCenter.NoticeListCell)
local DecrementUnreadTencentNoticeCount = require(Modules.Luobu.Actions.DecrementUnreadTencentNoticeCount)
local ReadTencentNoticeId = require(Modules.Luobu.Actions.ReadTencentNoticeId)
local TencentNoticeType = require(Modules.Luobu.Enum.TencentNoticeType)
local MemStorageKeys = require(Modules.Luobu.Enum.MemStorageKeys)
local v21 = Roact.PureComponent:extend("TencentNoticeItemContainer")

v21.validateProps = t.strictInterface({
	layoutInfo = t.table,
	item = t.optional(t.table),
	dateText = t.optional(t.string),
	navigateDown = t.callback,
	decrementUnreadTencentNoticeCount = t.callback,
	readTencentNoticeId = t.callback,
	noticeReadStatus = t.table
})

local function getDateText(p1) -- line: 38
	-- upvalues: DateTime (copy), LocalizationService (copy), TimeZone (copy)
	local v26 = DateTime.fromUnixTimestamp(p1)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	return (v26:GetLongRelativeTime(v26, TimeZone.Current, RobloxLocaleId))
end

function v21.init(p2) -- line: 45
	-- upvalues: TencentNoticeType (copy), AppPage (copy)
	function p2.onActivated() -- line: 46
		-- upvalues: p2 (copy), TencentNoticeType (copy), AppPage (copy)
		local item = p2.props.item

		if item.type == TencentNoticeType.Web then
			p2.props.navigateDown({
				name = AppPage.GenericWebPage,
				detail = item.webTypeUrl or item.noticeUrl,
				extraProps = {
					title = item.title
				}
			})
		else
			p2.props.navigateDown({
				name = AppPage.TencentNoticeContent,
				extraProps = {
					notice = item,
					dateText = p2.props.dateText
				}
			})
		end

		local noticeReadStatus = p2.props.noticeReadStatus

		if (item.hasRead or (noticeReadStatus[item.noticeId] or false)) == false then
			p2:fireNoticeIdHasRead(item.noticeId, item.endTime)
		end
	end
end
function v21.fireNoticeIdHasRead(p3, p4, p5) -- line: 73
	-- upvalues: MemStorageService (copy), MemStorageKeys (copy), HttpService (copy)
	MemStorageService:Fire(MemStorageKeys.TencentNoticeIdReadStatus, HttpService:JSONEncode({
		noticeId = p4,
		endTime = p5
	}))
	p3.props.decrementUnreadTencentNoticeCount()
	p3.props.readTencentNoticeId(p4)
end
function v21.render(p6) -- line: 86
	-- upvalues: Roact (copy), NoticeListCell (copy), Cryo (copy)
	local layoutInfo = p6.props.layoutInfo

	return Roact.createElement(NoticeListCell, Cryo.Dictionary.join(layoutInfo, {
		item = p6.props.item,
		dateText = p6.props.dateText,
		onActivated = p6.onActivated
	}))
end

local function mapStateToProps(p7, p8) -- line: 98
	-- upvalues: DateTime (copy), LocalizationService (copy), TimeZone (copy)
	local v36 = p8.item and p8.item.startTime or nil
	local t1 = {}
	local g41 = nil
	local LongRelativeTime = nil

	if v36 then
		local v38 = DateTime.fromUnixTimestamp(v36)
		local RobloxLocaleId = LocalizationService.RobloxLocaleId

		LongRelativeTime = v38:GetLongRelativeTime(v38, TimeZone.Current, RobloxLocaleId)

		if LongRelativeTime then
			g41 = true
		end
	end

	if not g41 then
		LongRelativeTime = nil
	end

	g41 = false
	t1.dateText = LongRelativeTime
	t1.noticeReadStatus = p7.Luobu.TencentNoticeReadStatus

	return t1
end
local function mapDispatchToProps(p9) -- line: 106
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy), DecrementUnreadTencentNoticeCount (copy), ReadTencentNoticeId (copy)
	return {
		navigateDown = function(p10) -- line: 108
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v14 (copy), p9 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v14.down(v14.fromLegacyPage(p10))

				return
			end

			p9(NavigateDown(p10))
		end,
		decrementUnreadTencentNoticeCount = function() -- line: 115
			-- upvalues: p9 (copy), DecrementUnreadTencentNoticeCount (copy)
			return p9(DecrementUnreadTencentNoticeCount())
		end,
		readTencentNoticeId = function(p11) -- line: 118
			-- upvalues: p9 (copy), ReadTencentNoticeId (copy)
			return p9(ReadTencentNoticeId(p11))
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v21))
