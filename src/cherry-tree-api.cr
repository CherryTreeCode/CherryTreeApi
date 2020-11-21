require "kemal"
require "graphql"

module Cherry::Tree::Api
  VERSION = "0.1.0"

  @[GraphQL::Object]
  class Query
    include GraphQL::ObjectType
    include GraphQL::QueryType

    @[GraphQL::Field]
    def echo(str : String) : String
      str
    end
  end

  schema = GraphQL::Schema.new(Query.new)

  post "/graphql" do |env|
    env.response.content_type = "application/json"

    query = env.params.json["query"].as(String)
    variables = env.params.json["variables"]?.as(Hash(String, JSON::Any)?)
    operation_name = env.params.json["operationName"]?.as(String?)

    schema.execute(query, variables, operation_name)
  end

  Kemal.run # TODO: Put your code here
end
