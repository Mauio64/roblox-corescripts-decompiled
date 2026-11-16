local Version = require(script.Parent.Version)
local DsnUtils = {}

function DsnUtils.parse_dsn(value: string)
	if not value or value == "" then
		return nil, "DSN is required"
	end

	local match, v, v2 = value:match("^(https?)://([^@]+)@(.+)$")

	if not (match and v and v2) then
		return nil, "Invalid DSN format"
	end

	local public_key, v3 = v:match("^([^:]+):(.+)$")

	if not public_key then
		public_key = v
		v3 = ""
	end

	if not public_key or public_key == "" then
		return nil, "Invalid DSN format"
	end

	local match2, path = v2:match("^([^/]+)(.*)$")

	if not match2 or not path or path == "" then
		return nil, "Invalid DSN format"
	end

	local match3 = path:match("/([%d]+)$")

	if match3 then
		return {
			protocol = match,
			public_key = public_key,
			secret_key = v3 or "",
			host = match2,
			path = path,
			project_id = match3
		}, nil
	end

	return nil, "Could not extract project ID from DSN"
end

function DsnUtils.build_ingest_url(p)
	return `https://{p.host}/api/{p.project_id}/store/`
end

function DsnUtils.build_envelope_url(p)
	return `https://{p.host}/api/{p.project_id}/envelope/`
end

function DsnUtils.build_auth_header(p)
	return `Sentry sentry_version={Version.SENTRY_VERSION}, sentry_key={p.public_key}, sentry_client=sentry-lua/{Version.SDK_VERSION}`
end

return DsnUtils
