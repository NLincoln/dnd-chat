defmodule DndChat.DiceRoller do
  @spec execute_roll(binary()) :: any()
  def execute_roll(roll_string) do
    cwd = File.cwd!()

    result =
      Porcelain.exec("node", ["#{cwd}/assets/dice-roller.js"],
        in: [roll_string, "\n"],
        dir: "#{cwd}/assets"
      )

    Jason.decode(String.trim(result.out))
  end

  def execute_roll!(roll_string) do
    {:ok, result} = execute_roll(roll_string)
    result
  end
end
