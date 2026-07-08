local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local u3 = nil
local u4 = nil
local LocaleId = nil
local u6 = nil
local BindableEvent = Instance.new("BindableEvent")

local function handlePlayerOrLocaleChanged() -- line: 11
	-- upvalues: u4 (ref), LocaleId (ref), BindableEvent (copy)
	if u4 and u4.LocaleId ~= LocaleId then
		LocaleId = u4.LocaleId
		BindableEvent:Fire(LocaleId)
	end
end
local function reset() -- line: 18
	-- upvalues: u3 (ref), u4 (ref), u6 (ref)
	u3 = nil
	u4 = nil

	if u6 then
		u6:Disconnect()
		u6 = nil
	end
end
local function getTranslator() -- line: 28
	-- upvalues: u3 (ref), u4 (ref), Players (copy), LocalizationService (copy), LocaleId (ref), BindableEvent (copy), u6 (ref), handlePlayerOrLocaleChanged (copy)
	if not u3 then
		u4 = Players.LocalPlayer

		if u4 then
			u3 = LocalizationService:GetTranslatorForPlayer(u4)

			if u4 and u4.LocaleId ~= LocaleId then
				LocaleId = u4.LocaleId
				BindableEvent:Fire(LocaleId)
			end

			u6 = u4:GetPropertyChangedSignal("LocaleId"):Connect(handlePlayerOrLocaleChanged)
		end
	end

	return u3
end

local t1 = {}

local function unregisterGui(p1) -- line: 43
	-- upvalues: t1 (copy)
	local v20 = t1[p1]

	if not v20 then
		return
	end

	v20.connection:Disconnect()
	t1[p1] = nil
end
local function makeAncestryChangedHandler(p2, p3) -- line: 52
	-- upvalues: t1 (copy)
	return function(_, _) -- line: 53
		-- upvalues: p2 (copy), p3 (copy), t1 (copy)
		if not game:IsAncestorOf(p2) then
			if p3.hasBeenAdded then
				local v47 = p2
				local v48 = t1[v47]

				if not v48 then
					return
				end

				v48.connection:Disconnect()
				t1[v47] = nil

				return
			end
		else
			p3.hasBeenAdded = true
		end
	end
end
local function updateRegistryInfo(p6, p7, p8) -- line: 64
	p6.context = p7
	p6.text = p8
end
local function makeRegistryInfo(p9, p10, p11) -- line: 69
	-- upvalues: t1 (copy)
	local t2 = {
		hasBeenAdded = game:IsAncestorOf(p9),
		context = p10,
		text = p11
	}

	t2.connection = p9.AncestryChanged:Connect(function(_, _) -- line: 53
		-- upvalues: p9 (copy), t2 (copy), t1 (copy)
		if not game:IsAncestorOf(p9) then
			if t2.hasBeenAdded then
				local v51 = p9
				local v52 = t1[v51]

				if not v52 then
					return
				end

				v52.connection:Disconnect()
				t1[v51] = nil

				return
			end
		else
			t2.hasBeenAdded = true
		end
	end)

	return t2
end
local function registerGui(p14, p15, p16) -- line: 77
	-- upvalues: t1 (copy), makeRegistryInfo (copy)
	if t1[p14] == nil then
		t1[p14] = makeRegistryInfo(p14, p15, p16)

		return
	end

	local v33 = t1[p14]

	v33.context = p15
	v33.text = p16
end

Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 85
	-- upvalues: u3 (ref), u4 (ref), u6 (ref), Players (copy), LocalizationService (copy), LocaleId (ref), BindableEvent (copy), handlePlayerOrLocaleChanged (copy)
	u3 = nil
	u4 = nil

	if u6 then
		u6:Disconnect()
		u6 = nil
	end

	if not u3 then
		u4 = Players.LocalPlayer

		if u4 then
			u3 = LocalizationService:GetTranslatorForPlayer(u4)

			if u4 and u4.LocaleId ~= LocaleId then
				LocaleId = u4.LocaleId
				BindableEvent:Fire(LocaleId)
			end

			u6 = u4:GetPropertyChangedSignal("LocaleId"):Connect(handlePlayerOrLocaleChanged)
		end
	end
end)

local t3 = {
	LocaleChanged = BindableEvent.Event,
	TranslateGameText = function(_, p18, p19) -- line: 101
		-- upvalues: u3 (ref), u4 (ref), Players (copy), LocalizationService (copy), LocaleId (ref), BindableEvent (copy), u6 (ref), handlePlayerOrLocaleChanged (copy)
		if not u3 then
			u4 = Players.LocalPlayer

			if u4 then
				u3 = LocalizationService:GetTranslatorForPlayer(u4)

				if u4 and u4.LocaleId ~= LocaleId then
					LocaleId = u4.LocaleId
					BindableEvent:Fire(LocaleId)
				end

				u6 = u4:GetPropertyChangedSignal("LocaleId"):Connect(handlePlayerOrLocaleChanged)
			end
		end

		local v37 = u3

		if v37 then
			return v37:RobloxOnlyTranslate(p18, p19)
		end

		return p19
	end
}

local function retranslateAll() -- line: 110
	-- upvalues: t1 (copy), t3 (copy)
	for k, v in pairs(t1) do
		k.Text = t3:TranslateGameText(v.context, v.text)
	end
end

LocalizationService.AutoTranslateWillRun:Connect(retranslateAll)

function t3.TranslateAndRegister(p20, p21, p22, p23) -- line: 118
	-- upvalues: t1 (copy), makeRegistryInfo (copy)
	p21.Text = p20:TranslateGameText(p22, p23)

	if t1[p21] == nil then
		t1[p21] = makeRegistryInfo(p21, p22, p23)

		return p23
	end

	local v44 = t1[p21]

	v44.context = p22
	v44.text = p23

	return p23
end

return t3
