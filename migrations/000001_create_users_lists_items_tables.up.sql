CREATE TABLE IF NOT EXISTS users (
    user_id bigserial PRIMARY KEY,
    created_at timestamp(0) with time zone NOT NULL DEFAULT NOW(),
    name varchar(100) NOT NULL,
    email citext UNIQUE NOT NULL,
    password_hash bytea NOT NULL
);

CREATE TABLE IF NOT EXISTS lists (
    list_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    owner_user_id bigserial REFERENCES users(user_id) ON DELETE SET NULL,
    share_token UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- For shareable links
    created_at timestamp(0) with time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp(0) with time zone
);


CREATE TABLE IF NOT EXISTS items (
    item_id bigserial PRIMARY KEY,
    list_id UUID NOT NULL REFERENCES lists(list_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL
);

-- join/junctional table
CREATE TABLE IF NOT EXISTS users_lists (
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    list_id INT NOT NULL REFERENCES lists(list_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, list_id)
);

-- TODO: add priviliges
-- [] - User can modify and read or only read
