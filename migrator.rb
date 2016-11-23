require 'json'
require 'fileutils'

class Migrator

    attr_accessor :file_path, :source, :posts, :relations, :tags
    
    def initialize(file_path)
        @file_path = file_path
        parse
    end

    def parse
        file = File.read @file_path
        @source = JSON.parse file
        @posts = @source['db'].first['data']['posts']
        @relations = @source['db'].first['data']['posts_tags']
        @tags = @source['db'].first['data']['tags']
    end

    def relative_tags(post)
        relations = @relations.select { |rel| rel['post_id'] == post['id'] }
        return nil if relations.empty?
        tag_ids = relations.collect { |relation| relation['tag_id'] }
            .uniq
        tag_names = @tags.select { |tag| tag_ids.include? tag['id']}
            .collect { |tag| tag['name'] } 
    end

    def generate
        @posts.each { |post| create_post_file(post) }
    end

    def create_post_file(post)
        created_date = post['created_at'].split('T').first
        path = "./_posts/#{ created_date }-#{ post['title'] }.md"

        dir = File.dirname(path)
        unless File.directory?(dir)
            FileUtils.mkdir_p(dir)
        end

        File.open(path, 'w') do |file|
            markdown_header = <<~HEAD.gsub(/\A[[:blank:]]+/ , '')
                    ---
                    layout: post
                    title: #{ post['title'] }
                    date: #{ created_date }
                    tags: #{ self.relative_tags(post).to_s.gsub('"', '') }
                    ---
                HEAD
            file.write "#{ markdown_header }\n#{ post['markdown'] }"
        end
    end

end