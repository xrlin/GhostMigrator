# GhostMigrator
## A script to tanslate blogs from ghost to standard markdown files.

### Usage

1. Clone the project.

2. Go into the project folder and run irb to enter the ruby shell. After run the commands below the markdown files are genearted in `./_post` folder.

```ruby
require './migrator'
migrator = Migrator.new('your-json-file-path-export-from-ghost');
migrator.generate;
```

#### After tanslation you can use the markdown file in github pages.