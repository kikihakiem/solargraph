module Solargraph
  class SourceMap
    module NodeProcessor
      class AliasNode < Base
        def process
          loc = get_node_location(node)
          pin = pins.select{|p| [Solargraph::Pin::Method, Solargraph::Pin::Attribute].include?(p.class) && p.name == node.children[1].children[0].to_s && p.namespace == region.namespace && p.scope == region.scope}.first
          if pin.nil?
            # pins.push Solargraph::Pin::MethodAlias.new(get_node_location(node), region.namespace, node.children[0].children[0].to_s, region.scope, node.children[1].children[0].to_s)
            pins.push Solargraph::Pin::MethodAlias.new(
              location: loc,
              closure: closure_pin(loc.range.start),
              name: node.children[0].children[0].to_s,
              original: node.children[1].children[0].to_s,
              scope: region.scope
            )
          elsif pin.is_a?(Solargraph::Pin::Method)
            # pins.push Solargraph::Pin::Method.new(get_node_location(node), pin.namespace, node.children[0].children[0].to_s, comments_for(node) || pin.comments, pin.scope, pin.visibility, pin.parameters, pin.node)
            pins.push Solargraph::Pin::Method.new(
              location: loc,
              closure: closure_pin(loc.range.start),
              name: node.children[0].children[0].to_s,
              comments: comments_for(node) || pin.comments,
              scope: pin.scope,
              visibility: pin.visibility
            )
          elsif pin.is_a?(Solargraph::Pin::Attribute)
            # pins.push Solargraph::Pin::Attribute.new(get_node_location(node), pin.namespace, node.children[0].children[0].to_s, comments_for(node) || pin.comments, pin.access, pin.scope, pin.visibility)
            pins.push Solargraph::Pin::Attribute.new(
              location: loc,
              closure: closure_pin(loc.range.start),
              name: node.children[0].children[0].to_s,
              comments: comments_for(node) || pin.comments,
              scope: pin.scope,
              visibility: pin.visibility,
              access: pin.access
            )
          end
          process_children
        end
      end
    end
  end
end
