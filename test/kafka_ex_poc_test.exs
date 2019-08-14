defmodule KafkaExPocTest do
  use ExUnit.Case
  doctest KafkaExPoc

  test "greets the world" do
    assert KafkaExPoc.hello() == :world
  end
end
