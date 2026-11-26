local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")

local HttpService = game:GetService("HttpService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local dateTime = require("@luauforge/bundled/geM").DateTime
local timeZone = require("@luauforge/bundled/geM").TimeZone

local module = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module2 = require("@luauforge/bundled/dFu")
local module3 = require("@luauforge/deferred/geS")
local module4 = require("@luauforge/bundled/geT")
local module5 = require("@luauforge/bundled/geU")
local module6 = require("@luauforge/bundled/geV")
local module7 = require("@luauforge/deferred/geW")

local extended = Roact.PureComponent:extend("TencentNoticeItemContainer")

extended.validateProps = t.strictInterface({
	layoutInfo = t.table,
	item = t.optional(t.table),
	dateText = t.optional(t.string),
	navigateDown = t.callback,
	decrementUnreadTencentNoticeCount = t.callback,
	readTencentNoticeId = t.callback,
	noticeReadStatus = t.table
})

local function getDateText(p2)
	local v5 = dateTime.fromUnixTimestamp(p2)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	return (v5:GetLongRelativeTime(v5, timeZone.Current, robloxLocaleId))
end

function extended:init()
	function self.onActivated()
		local item = self.props.item

		if item.type == module6.Web then
			self.props.navigateDown({
				name = module2.GenericWebPage,
				detail = item.webTypeUrl or item.noticeUrl,
				extraProps = { title = item.title }
			})
		else
			self.props.navigateDown({
				name = module2.TencentNoticeContent,
				extraProps = { notice = item, dateText = self.props.dateText }
			})
		end

		local noticeReadStatus = self.props.noticeReadStatus

		if (item.hasRead or noticeReadStatus[item.noticeId] or false) == false then
			self:fireNoticeIdHasRead(item.noticeId, item.endTime)
		end
	end
end

function extended:fireNoticeIdHasRead(p3, p4)
	MemStorageService:Fire(
		module7.TencentNoticeIdReadStatus,
		HttpService:JSONEncode({ noticeId = p3, endTime = p4 })
	)

	self.props.decrementUnreadTencentNoticeCount()
	self.props.readTencentNoticeId(p3)
end

function extended.render(p2)
	local layoutInfo = p2.props.layoutInfo
	return Roact.createElement(
		module3,
		Cryo.Dictionary.join(layoutInfo, {
			item = p2.props.item,
			dateText = p2.props.dateText,
			onActivated = p2.onActivated
		})
	)
end

local function mapStateToProps(p2, p3)
	local startTime = p3.item and p3.item.startTime or nil
	local longRelativeTime

	if startTime then
		local v6 = dateTime.fromUnixTimestamp(startTime)
		local robloxLocaleId = LocalizationService.RobloxLocaleId
		longRelativeTime = v6:GetLongRelativeTime(v6, timeZone.Current, robloxLocaleId) or nil
	end

	return {
		dateText = longRelativeTime,
		noticeReadStatus = p2.Luobu.TencentNoticeReadStatus
	}
end

local function mapDispatchToProps(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module(p2))
			end
		end,
		decrementUnreadTencentNoticeCount = function()
			return callback(module4())
		end,
		readTencentNoticeId = function(p2)
			return callback(module5(p2))
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))
