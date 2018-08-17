defmodule BatchQueueTest do
  use ExUnit.Case
  doctest GenServerExample

  setup do
    {:ok, pid} = BatchQueue.start_link()
    {:ok, pid: pid}
  end

  test "queue starts off empty", %{pid: pid} do
    assert BatchQueue.length(pid) == 0
    assert BatchQueue.list(pid) == []
  end

  test "push single item", %{pid: pid} do
    BatchQueue.push(pid, "item-1")

    assert BatchQueue.length(pid) == 1
    assert BatchQueue.list(pid) == ["item-1"]
  end

  test "push multiple items", %{pid: pid} do
    BatchQueue.push(pid, "item-1")
    BatchQueue.push(pid, "item-2")

    assert BatchQueue.length(pid) == 2
    assert BatchQueue.list(pid) == ["item-1", "item-2"]
  end

  test "pop returns correct item", %{pid: pid} do
    BatchQueue.push(pid, "item-1")
    BatchQueue.push(pid, "item-2")

    assert BatchQueue.pop(pid) == "item-1"
    assert BatchQueue.length(pid) == 1
    assert BatchQueue.list(pid) == ["item-2"]
  end

  test "popping empty queue works properly", %{pid: pid} do
    assert BatchQueue.pop(pid) == :empty
    assert BatchQueue.length(pid) == 0
  end
end
