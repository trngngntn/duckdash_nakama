local nkm = require('nakama')

local function initialize_user(context, payload)
    if payload.created then
        local changeset = {
            exp = 0,
            gold = 0,
            soul = 0,
            skp = 5
        }
        local metadata = {}
        nkm.wallet_update(context.user_id, changeset, metadata, true)
    end
end

nkm.register_req_after(initialize_user, "AuthenticateEmail")