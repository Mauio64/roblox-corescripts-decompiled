local v5 = { "%s(www%.[^%s]+)", "%shttps?://([^%s]+)" }
return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("ProcessSiteAlertInfoPayload", function(data)
	assert(
		type(data) == "table",
		string.format("UpdateSiteMessageBannerText action expects data to be a table, was %s", (type(data)))
	)

	local v6 = data.LinkUrl

	if v6 and #v6 == 0 then
		v6 = nil
	end

	if data.Text and not v6 then
		for i, v7 in ipairs(v5) do
			local v8, v9, v10 = string.find(data.Text, v7)

			if v8 then
				v6 = "https://" .. v10
			end
		end
	end

	return {
		text = data.Text,
		visible = data.IsVisible or false,
		link = v6,
		timestamp = data.timestamp or nil
	}
end)
