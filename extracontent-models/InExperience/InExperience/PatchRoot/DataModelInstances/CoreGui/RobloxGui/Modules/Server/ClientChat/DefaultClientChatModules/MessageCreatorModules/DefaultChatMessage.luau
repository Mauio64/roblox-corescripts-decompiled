local ok, result = pcall(function() -- line: 8
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local u3 = ok and result
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local ChatSettings = require(ParentParent:WaitForChild("ChatSettings"))
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local Util = require(script.Parent:WaitForChild("Util"))
local v9 = utf8.char(57344)

function IsPlayerVerified(p1) -- line: 23
	-- upvalues: Players (copy)
	local PlayerByUserId = Players:GetPlayerByUserId(p1)

	if not PlayerByUserId then
		return false
	end

	local ok2, result2 = pcall(function() -- line: 30
		-- upvalues: PlayerByUserId (copy)
		return PlayerByUserId.HasVerifiedBadge
	end)

	if ok2 then
		return result2
	end

	return false
end
function AppendVerifiedBadge(p2) -- line: 37
	-- upvalues: v9 (copy)
	return p2 .. v9
end
function CreateMessageLabel(p3, p4, p5) -- line: 41
	-- upvalues: ChatSettings (copy), Util (copy), u3 (ref)
	local FromSpeaker = p3.FromSpeaker
	local v19 = if not ChatSettings.PlayerDisplayNamesEnabled or not p3.SpeakerDisplayName then FromSpeaker else p3.SpeakerDisplayName
	local SpeakerUserId = p3.SpeakerUserId

	if IsPlayerVerified(SpeakerUserId) then
		v19 = AppendVerifiedBadge(v19)
	end

	local _ = p3.Message
	local v22 = p3.ExtraData or {}
	local v23 = v22.Font or ChatSettings.DefaultFont
	local v24 = v22.TextSize or ChatSettings.ChatWindowTextSize
	local v25 = v22.NameColor or ChatSettings.DefaultNameColor
	local v26 = v22.ChatColor or ChatSettings.DefaultMessageColor
	local v27 = v22.ChannelColor or v26
	local v28 = v22.Tags or {}
	local v29 = string.format("[%s]:", v19)

	Util:GetStringTextBounds(v29, v23, v24)

	local u30 = Util:GetNumberOfSpaces(v29, v23, v24) + 1
	local v31, v32 = Util:CreateBaseMessage("", v23, v24, v26)
	local v33 = Util:AddNameButtonToBaseMessage(v32, v25, v29, FromSpeaker)
	local v34 = nil
	local uDim2 = UDim2.new(0, 0, 0, 0)

	if p4 ~= p3.OriginalChannel then
		local v36 = string.format("{%s}", p3.OriginalChannel)

		v34 = Util:AddChannelButtonToBaseMessage(v32, v27, v36, p3.OriginalChannel)
		uDim2 = UDim2.new(0, v34.Size.X.Offset + Util:GetStringTextBounds(" ", v23, v24).X, 0, 0)
		u30 = u30 + Util:GetNumberOfSpaces(v36, v23, v24) + 1
	end

	local t1 = {}

	for _, v in pairs(v28) do
		local v40 = v.TagColor or Color3.fromRGB(255, 0, 255)
		local v41 = v.TagText or "???"
		local v42 = string.format("[%s] ", v41)
		local v43 = Util:AddTagLabelToBaseMessage(v32, v40, v42)

		v43.Position = uDim2
		u30 += Util:GetNumberOfSpaces(v42, v23, v24)
		uDim2 += UDim2.new(0, v43.Size.X.Offset, 0, 0)
		table.insert(t1, v43)
	end

	v33.Position = uDim2

	local u44 = false
	local u45 = nil

	if u3 then
		pcall(function() -- line: 105
			-- upvalues: u45 (ref), Util (copy), v32 (copy), uDim2 (ref), v33 (copy)
			u45 = Util:AddTranslationButtonToBaseMessage(v32)
			uDim2 += UDim2.new(0, v33.Size.X.Offset + 2, 0, 0)
			u45.Position = uDim2
		end)
	end

	local function useOriginalText(p6) -- line: 112
		-- upvalues: u44 (ref), p3 (copy), v32 (copy), Util (copy), u30 (ref)
		u44 = false

		if p3.IsFiltered then
			v32.Text = Util:CreateLeadingSpaces(u30) .. Util:SanitizeForRichText(p6.Message)

			return
		end

		local v61 = p6.MessageLengthUtf8 or p6.MessageLength

		v32.Text = Util:CreateLeadingSpaces(u30) .. string.rep("_", v61)
	end
	local function useTranslatedText(p7) -- line: 122
		-- upvalues: u45 (ref), u30 (ref), u44 (ref), useOriginalText (copy), v32 (copy), Util (copy)
		if u45 == nil then
			return
		end

		if u45.Visible == false then
			u30 += 6
		end

		u45.Visible = true
		u44 = true

		if p7.TranslatedMessage == "" then
			useOriginalText(p7)

			return
		end

		v32.Text = Util:CreateLeadingSpaces(u30) .. Util:SanitizeForRichText(p7.TranslatedMessage)
	end
	local function UpdateTextFunction_Chat(p8) -- line: 142
		-- upvalues: p3 (copy), u45 (ref), u30 (ref), u44 (ref), useOriginalText (copy), v32 (copy), Util (copy)
		p3.TranslatedMessage = p8.TranslatedMessage

		if p8.TranslatedMessage then
			if u45 == nil then
				return
			end

			if u45.Visible == false then
				u30 += 6
			end

			u45.Visible = true
			u44 = true

			if p8.TranslatedMessage == "" then
				useOriginalText(p8)

				return
			end

			v32.Text = Util:CreateLeadingSpaces(u30) .. Util:SanitizeForRichText(p8.TranslatedMessage)

			return
		end

		useOriginalText(p8)
	end
	local function UpdateTextFunction(p9) -- line: 151
		-- upvalues: u3 (ref), p3 (copy), u45 (ref), u30 (ref), u44 (ref), useOriginalText (copy), v32 (copy), Util (copy)
		if u3 then
			p3.TranslatedMessage = p9.TranslatedMessage

			if p9.TranslatedMessage then
				if u45 == nil then
					return
				end

				if u45.Visible == false then
					u30 += 6
				end

				u45.Visible = true
				u44 = true

				if p9.TranslatedMessage == "" then
					useOriginalText(p9)

					return
				end

				v32.Text = Util:CreateLeadingSpaces(u30) .. Util:SanitizeForRichText(p9.TranslatedMessage)

				return
			end

			useOriginalText(p9)

			return
		end

		if p3.IsFiltered then
			v32.Text = Util:CreateLeadingSpaces(u30) .. Util:SanitizeForRichText(p9.Message)

			return
		end

		local v65 = p9.MessageLengthUtf8 or p9.MessageLength

		v32.Text = Util:CreateLeadingSpaces(u30) .. string.rep("_", v65)
	end
	local function toggleTranslation() -- line: 164
		-- upvalues: u44 (ref), p3 (copy), u45 (ref), u30 (ref), useOriginalText (copy), v32 (copy), Util (copy), p5 (copy)
		if not u44 and p3.TranslatedMessage then
			local v66 = p3

			if u45 ~= nil then
				if u45.Visible == false then
					u30 += 6
				end

				u45.Visible = true
				u44 = true

				if v66.TranslatedMessage == "" then
					useOriginalText(v66)
				else
					v32.Text = Util:CreateLeadingSpaces(u30) .. Util:SanitizeForRichText(v66.TranslatedMessage)
				end
			end
		else
			useOriginalText(p3)
		end

		if p5 then
			p5()
		end
	end

	if u3 and u45 ~= nil then
		local v51 = u45.MouseButton1Click:connect(function() -- line: 176
			-- upvalues: u44 (ref), p3 (copy), u45 (ref), u30 (ref), useOriginalText (copy), v32 (copy), Util (copy), p5 (copy)
			if not u44 and p3.TranslatedMessage then
				local v67 = p3

				if u45 ~= nil then
					if u45.Visible == false then
						u30 += 6
					end

					u45.Visible = true
					u44 = true

					if v67.TranslatedMessage == "" then
						useOriginalText(v67)
					else
						v32.Text = Util:CreateLeadingSpaces(u30) .. Util:SanitizeForRichText(v67.TranslatedMessage)
					end
				end
			else
				useOriginalText(p3)
			end

			if p5 then
				p5()
			end
		end)
		local u52 = nil

		u52 = u45.Changed:connect(function(p10) -- line: 181
			-- upvalues: v51 (copy), u52 (ref)
			if p10 == "Parent" then
				v51:Disconnect()
				u52:Disconnect()
			end
		end)
	end

	UpdateTextFunction(p3)

	local function GetHeightFunction(p11) -- line: 191
		-- upvalues: Util (copy), v32 (copy), v31 (copy)
		return Util:GetMessageHeight(v32, v31, p11)
	end

	local t2 = {
		[v33] = {
			TextTransparency = {
				FadedIn = 0,
				FadedOut = 1
			},
			TextStrokeTransparency = {
				FadedIn = 0.75,
				FadedOut = 1
			}
		}
	}

	if u3 and u45 ~= nil then
		t2[u45] = {
			ImageTransparency = {
				FadedIn = 0,
				FadedOut = 1
			}
		}
	end

	t2[v32] = {
		TextTransparency = {
			FadedIn = 0,
			FadedOut = 1
		},
		TextStrokeTransparency = {
			FadedIn = 0.75,
			FadedOut = 1
		}
	}

	for k, v in pairs(t1) do
		string.format("Tag%d", k)
		t2[v] = {
			TextTransparency = {
				FadedIn = 0,
				FadedOut = 1
			},
			TextStrokeTransparency = {
				FadedIn = 0.75,
				FadedOut = 1
			}
		}
	end

	if v34 then
		t2[v34] = {
			TextTransparency = {
				FadedIn = 0,
				FadedOut = 1
			},
			TextStrokeTransparency = {
				FadedIn = 0.75,
				FadedOut = 1
			}
		}
	end

	local v57, v58, v59 = Util:CreateFadeFunctions(t2)

	return {
		[Util.KEY_BASE_FRAME] = v31,
		[Util.KEY_BASE_MESSAGE] = v32,
		[Util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[Util.KEY_GET_HEIGHT] = GetHeightFunction,
		[Util.KEY_FADE_IN] = v57,
		[Util.KEY_FADE_OUT] = v58,
		[Util.KEY_UPDATE_ANIMATION] = v59
	}
end

return {
	[Util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeDefault,
	[Util.KEY_CREATOR_FUNCTION] = CreateMessageLabel
}
