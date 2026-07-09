local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local TencentNoticeModel = require(Modules.Luobu.Models.TencentNoticeModel)
local SetTencentNoticeInfo = require(Modules.Luobu.Actions.SetTencentNoticeInfo)
local SetTencentNoticeBadgeCount = require(Modules.Luobu.Actions.SetTencentNoticeBadgeCount)
local ReadTencentNoticeId = require(Modules.Luobu.Actions.ReadTencentNoticeId)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local TencentNoticeSceneType = require(Modules.Luobu.Enum.TencentNoticeSceneType)
local TencentNoticeType = require(Modules.Luobu.Enum.TencentNoticeType)
local FFlagLuobuCJVMorePageShowTencentNotice = require(Modules.Luobu.Flags.FFlagLuobuCJVMorePageShowTencentNotice)
local FFlagLuobuShowTencentNoticePopup = require(Modules.Luobu.Flags.FFlagLuobuShowTencentNoticePopup)
local v14 = Roact.Component:extend("TencentNoticeEventReceiver")

function v14.init(p1) -- line: 18
	-- upvalues: TencentNoticeModel (copy), TencentNoticeType (copy), TencentNoticeSceneType (copy), FFlagLuobuShowTencentNoticePopup (copy), FFlagLuobuCJVMorePageShowTencentNotice (copy)
	p1.connections = { p1.props.RobloxEventReceiver:observeEvent("SyncTencentNoticeInformation", function(p2, p3) -- line: 20
		-- upvalues: TencentNoticeModel (copy), TencentNoticeType (copy), TencentNoticeSceneType (copy), p1 (copy), FFlagLuobuShowTencentNoticePopup (copy), FFlagLuobuCJVMorePageShowTencentNotice (copy)
		local t1 = {}
		local t2 = {}
		local t3 = {}
		local n1 = 0

		for _, v in ipairs(p2) do
			local v29 = TencentNoticeModel.fromJsonData(v)

			if v29 ~= nil then
				table.insert(t3, v29)

				if v29.hasRead == false then
					n1 += 1

					if v29.type == TencentNoticeType.Text or v29.type == TencentNoticeType.Image then
						if v29.scene == TencentNoticeSceneType.BeforeLogin then
							table.insert(t1, v29)
						elseif v29.scene == TencentNoticeSceneType.AfterLogin then
							table.insert(t2, v29)
						end
					end
				else
					p1.props.readTencentNoticeId(v29.noticeId)
				end
			end
		end

		if FFlagLuobuShowTencentNoticePopup then
			if p3 == TencentNoticeSceneType.AfterLogin and #t2 > 0 then
				p1.props.openTencentNoticePopup(t2)
			elseif p3 == TencentNoticeSceneType.BeforeLogin and #t1 > 0 then
				p1.props.openTencentNoticePopup(t1)
			end
		end

		if FFlagLuobuCJVMorePageShowTencentNotice then
			p1.props.setTencentNoticeInfo(t3)

			if n1 > 0 then
				p1.props.setTencentNoticeBadgeCount(n1)
			end
		end
	end) }
end
function v14.render(_) -- line: 66
end
function v14.willUnmount(p5) -- line: 68
	for _, v in pairs(p5.connections) do
		v:disconnect()
	end
end

return (RoactRodux.connect(nil, function(p6) -- line: 74
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy), SetTencentNoticeInfo (copy), ReadTencentNoticeId (copy), SetTencentNoticeBadgeCount (copy)
	return {
		openTencentNoticePopup = function(p7) -- line: 76
			-- upvalues: p6 (copy), SetCentralOverlay (copy), OverlayType (copy)
			return p6(SetCentralOverlay(OverlayType.TencentNoticePopup, {
				noticeList = p7
			}))
		end,
		setTencentNoticeInfo = function(p8) -- line: 81
			-- upvalues: p6 (copy), SetTencentNoticeInfo (copy)
			return p6(SetTencentNoticeInfo(p8))
		end,
		readTencentNoticeId = function(p9) -- line: 84
			-- upvalues: p6 (copy), ReadTencentNoticeId (copy)
			return p6(ReadTencentNoticeId(p9))
		end,
		setTencentNoticeBadgeCount = function(p10) -- line: 87
			-- upvalues: p6 (copy), SetTencentNoticeBadgeCount (copy)
			return p6(SetTencentNoticeBadgeCount(p10))
		end
	}
end)(v14))
