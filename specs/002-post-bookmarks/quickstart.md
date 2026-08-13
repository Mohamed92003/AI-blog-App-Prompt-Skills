# Quickstart: Post Bookmarks

## Overview
This feature adds the ability for authenticated users to bookmark posts and view their saved posts on a dedicated screen.

## Database Setup (Supabase)
To run this feature locally, you need to set up the `bookmarks` table in your Supabase project.

```sql
-- Create bookmarks table
CREATE TABLE bookmarks (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, post_id)
);

-- Enable RLS
ALTER TABLE bookmarks ENABLE ROW LEVEL SECURITY;

-- Add policies
CREATE POLICY "Users can view their own bookmarks" ON bookmarks
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own bookmarks" ON bookmarks
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own bookmarks" ON bookmarks
    FOR DELETE USING (auth.uid() = user_id);
```

## Running Locally
1. Ensure your `.env` contains valid Supabase URL and Anon Key.
2. Run the database migration script or apply the above SQL to your local Supabase instance.
3. Run the app: `flutter run`
4. Login as a user, tap the bookmark icon on a post, and check the Bookmarks tab in the bottom navigation bar.
