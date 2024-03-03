# Use an official Elixir runtime as a parent image
FROM elixir:1.12

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install project dependencies
RUN mix deps.get

# Compile the project
# RUN mix compile

# Run migrations (if needed)
# RUN mix ecto.migrate

# Expose Phoenix port
EXPOSE 4000

# Run the Phoenix server
CMD ["mix", "phx.server"]
