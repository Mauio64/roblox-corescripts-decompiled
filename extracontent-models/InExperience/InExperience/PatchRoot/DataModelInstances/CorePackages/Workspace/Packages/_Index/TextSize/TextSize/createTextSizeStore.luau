local TextService = game:GetService("TextService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local parent = script:FindFirstAncestor("TextSize").Parent
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)

local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function calculateTextSizeOffset()
	local function fn()
		local font = Font.fromEnum(Enum.Font.BuilderSans)

		local success, result = pcall(function()
			return TextService:GetTextSizeOffsetAsync(0, font)
		end)

		if success then
			return result or 0
		end

		warn(result)
		return 0
	end

	local thread = coroutine.create(fn)
	return (function(thread2: thread, flag: boolean, ...)
		if not flag then
			return nil
		end

		if coroutine.status(thread2) == "dead" then
			return ...
		end

		return nil
	end)(thread, coroutine.resume(thread)) or 0
end

local function createTextSizeStore()
	local createSignal = Signals.createSignal
	local v

	if FoundationFontFaceMigration then
		v = Foundation.Utility.getTextSizeOffset() or 0
	else
		local function fn()
			local font = Font.fromEnum(Enum.Font.BuilderSans)

			local success, result = pcall(function()
				return TextService:GetTextSizeOffsetAsync(0, font)
			end)

			if success then
				return result or 0
			end

			warn(result)
			return 0
		end

		local thread = coroutine.create(fn)
		v = (function(thread2: thread, flag: boolean, ...)
			if not flag then
				return nil
			end

			if coroutine.status(thread2) == "dead" then
				return ...
			end

			return nil
		end)(thread, coroutine.resume(thread)) or 0
	end

	local signal, v2 = createSignal(v)

	local preferredTextSizeChangedConnection = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(function()
		local v3

		if FoundationFontFaceMigration then
			v3 = Foundation.Utility.getTextSizeOffset() or 0
		else
			local function fn()
				local font = Font.fromEnum(Enum.Font.BuilderSans)

				local success, result = pcall(function()
					return TextService:GetTextSizeOffsetAsync(0, font)
				end)

				if success then
					return result or 0
				end

				warn(result)
				return 0
			end

			local thread = coroutine.create(fn)
			v3 = (function(thread2: thread, flag: boolean, ...)
				if not flag then
					return nil
				end

				if coroutine.status(thread2) == "dead" then
					return ...
				end

				return nil
			end)(thread, coroutine.resume(thread)) or 0
		end

		v2(v3)
	end)

	return {
		getTextSizeOffset = signal,
		cleanup = function()
			if preferredTextSizeChangedConnection then
				preferredTextSizeChangedConnection:Disconnect()
				preferredTextSizeChangedConnection = nil
			end
		end
	}
end

return createTextSizeStore
