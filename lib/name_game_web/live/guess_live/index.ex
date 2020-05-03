defmodule NameGameWeb.GuessLive.Index do
  use NameGameWeb, :live_view

  require Logger

  @default_guesses ~w(Brian Ted Ryan)
  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:name, "Bryan")
      |> assign(:current_guess, "")
      |> assign(:last_added_guess, nil)
      |> assign(:guesses, @default_guesses)
      |> calc_scores()

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => _id}) do
    socket
    |> assign(:page_title, "Edit Guess")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Guess")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Guesses")
  end

  @impl true
  def handle_event("add-guess", _params, socket) do
    Logger.debug("add-guess!")
    guess = socket.assigns.current_guess
    guesses = [guess | socket.assigns.guesses]

    socket =
      socket
      |> assign(:current_guess, "")
      |> assign(:last_added_guess, guess)
      |> assign(:guesses, guesses)
      |> calc_scores()

    # {:noreply, push_patch(socket, to: "/##{guess}")}
    {:noreply, socket}
  end

  def handle_event("remove-guess", %{"guess" => guess}, socket) do
    Logger.debug("remove-guess! #{guess}")
    guesses = socket.assigns.guesses |> IO.inspect() |> List.delete(guess) |> IO.inspect()

    socket =
      socket
      |> assign(:guesses, guesses)
      |> calc_scores()

    {:noreply, socket}
  end

  def handle_event("update-guess", %{"value" => guess}, socket) do
    Logger.debug("update-guess!")

    socket =
      socket
      |> assign(:current_guess, guess)

    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    Logger.warn("unhandled event: #{event} - #{inspect(params)}")
    {:noreply, socket}
  end

  defp calc_scores(socket) do
    name = String.downcase(socket.assigns.name)
    guesses = socket.assigns.guesses
    scores = do_calc_scores(name, guesses)

    socket
    |> assign(:scores, scores)
  end

  defp do_calc_scores(name, guesses) when is_list(guesses) do
    guesses
    |> Enum.map(&do_calc_scores(name, &1))
    |> Enum.sort(&(&1.final_score <= &2.final_score))
  end

  defp do_calc_scores(name, og_guess) do
    guess = String.downcase(og_guess)

    %{
      name: og_guess,
      base_score: Levenshtein.distance(name, guess),
      correct_first_letter?: String.first(name) == String.first(guess),
      correct_length?: String.length(name) == String.length(guess),
      path: String.myers_difference(og_guess, String.capitalize(name))
    }
    |> adjust_score()
  end

  defp adjust_score(%{base_score: base, correct_first_letter?: cfl, correct_length?: cl} = result) do
    adjusted_score =
      case {cfl, cl} do
        {false, false} -> base
        {true, true} -> base - 2
        _ -> base - 1
      end

    result
    |> Map.put(:final_score, adjusted_score)
  end
end
