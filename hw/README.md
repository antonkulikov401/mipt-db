# Video sharing platform

- Userbase: everyone around the world.
- Functional requirements:
    - everyone (inlcuding non-registered users) can watch videos;
    - registered users can upload videos and create playlists;
    - registered users can like/dislike video.
- Nonfunctional requirements:
    - High availability;
    - Low latency;
    - Should scale well.
- Considerations:
    - consistency is not very important;
    - millions/billions of records;
    - transactions are small;
    - lots of simultaneous transactions;
    - reads are more frequent than writes.

Videos and images should be stored in external distributed file system (e.g., S3). In order to decrease delivery time and increse scalability, it is preferable to use CDN.

The rest of the data should be stored in a database which satisfies availability and partition tolerance (AP), for example, in DynamoDB.

Authorization can be implemented via OAuth and is out of scope.

## Logical model

See [dbml description](logical_model.dbml). It can be visulized on [dbdiagram.io](https://dbdiagram.io).

## Docs

Build using [dbdocs.io](https://dbdocs.io).

## Processes

- Video uploading
    1. Video file is uploaded to S3. Thumbnail is either provided by the user or is generated from uploaded video, and is uploaded to S3.
    2. Uploaded video goes through automatic moderation.
    3. Items in `Content` and `Video` tables are created.
    4. Original video is transcoded to other resolutions over time.
- Video searching
- Automatic resolution discovery

## Replication & backups

Videos should be replicated in different locations (to increase availability and reduce latency). Backups are unnecessary since there are no regulatory needs.

## Indices

- `Video(content_id)`.
- `Subscription(user_id)`.
- `WatchHistory(user_id)`.
- `LikeHistory(user_id)`.
- `PlaylistContent(playlist_id)`.
