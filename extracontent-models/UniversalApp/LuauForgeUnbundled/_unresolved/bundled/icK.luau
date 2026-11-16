local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module3 = require("@luauforge/bundled/icL")
local module4 = require("@luauforge/bundled/hJH")
local module5 = require("@luauforge/bundled/hJP")
local module6 = require("@luauforge/bundled/fAC")
local module7 = require("@luauforge/bundled/edP")
local module8 = require("@luauforge/bundled/edO")
local module9 = require("@luauforge/bundled/icM")
local module10 = require("@luauforge/bundled/fAD")
local module11 = require("@luauforge/bundled/hYj")
local module12 = require("@luauforge/bundled/hYl")

local extended = module.Component:extend("TencentNoticeEventReceiver")

function extended:init()
	self.connections = { self.props.RobloxEventReceiver:observeEvent(
			"SyncTencentNoticeInformation",
			function(list, p3)
				local v5 = {}
				local count = 0
				local v6 = {}
				local v7 = {}

				for i, item in ipairs(list) do
					local v8 = module3.fromJsonData(item)

					if v8 == nil then
						continue
					end

					table.insert(v5, v8)

					if v8.hasRead == false then
						count += 1

						if v8.type == module10.Text or v8.type == module10.Image then
							if v8.scene == module9.BeforeLogin then
								table.insert(v6, v8)
							elseif v8.scene == module9.AfterLogin then
								table.insert(v7, v8)
							end
						end
					else
						self.props.readTencentNoticeId(v8.noticeId)
					end
				end

				if module12 then
					if p3 == module9.AfterLogin and #v7 > 0 then
						self.props.openTencentNoticePopup(v7)
					elseif p3 == module9.BeforeLogin and #v6 > 0 then
						self.props.openTencentNoticePopup(v6)
					end
				end

				if module11 then
					self.props.setTencentNoticeInfo(v5)

					if count > 0 then
						self.props.setTencentNoticeBadgeCount(count)
					end
				end
			end
		) }
end

function extended.render(p2) end

function extended.willUnmount(p2)
	for k, connection in pairs(p2.connections) do
		connection:disconnect()
	end
end

return (useSheetNavigation.connect(nil, function(callback)
	return {
		openTencentNoticePopup = function(p2)
			return callback(module7(module8.TencentNoticePopup, { noticeList = p2 }))
		end,
		setTencentNoticeInfo = function(p2)
			return callback(module4(p2))
		end,
		readTencentNoticeId = function(p2)
			return callback(module6(p2))
		end,
		setTencentNoticeBadgeCount = function(p2)
			return callback(module5(p2))
		end
	}
end)(extended))
