defmodule BatchQueue do
  use GenServer

  def start_link() do
    GenServer.start_link(BatchQueue, :queue.new())
  end

  def init(queue) do
    {:ok, queue}
  end

  def handle_cast({:push, item}, queue) do
    {:noreply, :queue.in(item, queue)}
  end

  def handle_call(:list, _from, queue) do
    {:reply, :queue.to_list(queue), queue}
  end

  def handle_call(:length, _from, queue) do
    {:reply, :queue.len(queue), queue}
  end

  def handle_call(:pop, _from, queue) do
    with {{:value, item}, new_queue} <- :queue.out(queue) do
      {:reply, item, new_queue}
    else
      {:empty, _} ->
        {:reply, :empty, queue}
    end
  end

  # Public API
  def add(pid, item) do
    GenServer.cast(pid, {:add, item})
  end

  def list(pid) do
    GenServer.call(pid, :list)
  end

  def length(pid) do
    GenServer.call(pid, :length)
  end

  def push(pid, item) do
    GenServer.cast(pid, {:push, item})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end
end
