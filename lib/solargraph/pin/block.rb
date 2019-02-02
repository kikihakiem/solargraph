module Solargraph
  module Pin
    class Block < Closure
      # The signature of the method that receives this block.
      #
      # @return [Parser::AST::Node]
      attr_reader :receiver

      def initialize receiver: nil, **splat
        super(splat)
        @receiver = receiver
        @context = context
      end

      def rebind context
        @binder = context
      end

      def kind
        Pin::BLOCK
      end

      # @return [Array<String>]
      def parameters
        @parameters ||= []
      end

      # @return [Array<String>]
      def parameter_names
        @parameter_names ||= parameters.map{|p| p.split(/[ =:]/).first}
      end

      def nearly? other
        return false unless super
        # @todo Trying to not to block merges too much
        # receiver == other.receiver and parameters == other.parameters
        true
      end
    end
  end
end
