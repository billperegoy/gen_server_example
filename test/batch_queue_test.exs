defmodule BatchQueueTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = BatchQueue.start_link()
    %{pid: pid}
  end

  test "queue starts off empty", %{pid: pid} do
    assert BatchQueue.length(pid) == 0
    assert BatchQueue.list(pid) == []
  end

  test "add single item", %{pid: pid} do
    BatchQueue.add(pid, "item-1")

    assert BatchQueue.length(pid) == 1
    assert BatchQueue.list(pid) == ["item-1"]
  end

  test "add multiple items", %{pid: pid} do
    BatchQueue.add(pid, "item-1")
    BatchQueue.add(pid, "item-2")

    assert BatchQueue.length(pid) == 2
    assert BatchQueue.list(pid) == ["item-1", "item-2"]
  end

  test "fetch returns correct item", %{pid: pid} do
    BatchQueue.add(pid, "item-1")
    BatchQueue.add(pid, "item-2")

    assert BatchQueue.fetch(pid) == "item-1"
    assert BatchQueue.length(pid) == 1
    assert BatchQueue.list(pid) == ["item-2"]
  end

  test "fetching empty queue works properly", %{pid: pid} do
    assert BatchQueue.fetch(pid) == :empty
    assert BatchQueue.length(pid) == 0
  end
end
